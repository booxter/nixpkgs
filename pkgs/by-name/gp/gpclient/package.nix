{
  lib,
  rustPlatform,
  stdenv,
  fetchFromGitHub,
  atk,
  autoconf,
  automake,
  cairo,
  coreutils,
  darwin,
  gawk,
  glib,
  glib-networking,
  gmp,
  gnutls,
  gnugrep,
  gnused,
  gpauth,
  gtk3,
  iproute2,
  libtool,
  libxml2,
  lz4,
  makeBinaryWrapper,
  net-tools,
  nettle,
  nix-update-script,
  openresolv,
  openssl,
  p11-kit,
  pango,
  pciutils,
  perl,
  pkg-config,
  replaceVars,
  runtimeShell,
  systemd,
  unixtools,
  zlib,
  withSystemd ? lib.meta.availableOn stdenv.hostPlatform systemd,
}:

let
  runtimePath = lib.makeBinPath (
    [
      coreutils
      gawk
      unixtools.ps
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      iproute2
      pciutils # lspci
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.DarwinTools # sw_vers
    ]
    ++ lib.optionals withSystemd [
      systemd # resolvectl, systemctl, systemd-detect-virt
    ]
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gpclient";
  version = "3.0.2";

  src = fetchFromGitHub {
    owner = "yuezk";
    repo = "GlobalProtect-openconnect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1V9ZhkR/7GSB/nwwISVsBfPfnUQ/yMoU9D5MDjxcRrw=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-F8YM3y7xP7GlNXBMBg4qm4a6ySjBFWtRxDN5mkWsbis=";

  passthru.updateScript = nix-update-script { };

  meta = gpauth.meta // {
    # Anchor meta.position here so nixpkgs-update targets gpclient.
    inherit (gpauth.meta) description;
  };

  buildAndTestSubdir = "apps/gpclient";

  nativeBuildInputs = [
    makeBinaryWrapper
    perl
    pkg-config

    # used to build vendored openconnect
    autoconf
    automake
    libtool
  ];
  buildInputs = [
    glib
    glib-networking
    gmp
    gnutls
    gpauth

    # used for vendored openconnect
    libxml2
    lz4
    nettle
    openssl
    p11-kit
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    atk
    cairo
    gtk3
    pango
  ];

  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    # Fail in sandbox because netdev tries to read SystemConfiguration
    "--skip=connect::args::tests::deprecated_profile_override_flags_do_not_affect_os_profile"
    "--skip=connect::args::tests::stdin_host_id_sets_profile_runtime_identity_seed"
    "--skip=connect::flow_tests::"
    "--skip=session::tests::builds_session_context_from_os_profile"
  ];

  patches = [
    (replaceVars ./diagnostics-runtime.patch {
      inherit runtimeShell runtimePath;
    })
  ];

  postPatch = ''
    substituteInPlace crates/openconnect/src/vpn_utils.rs \
      --replace-fail /usr/local/libexec/gpclient/vpnc-script $out/libexec/gpclient/vpnc-script \
      --replace-fail /usr/libexec/gpclient/vpnc-script $out/libexec/gpclient/vpnc-script

    substituteInPlace crates/common/src/constants.rs \
      --replace-fail /usr/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /opt/homebrew/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /usr/local/bin/gpauth ${gpauth}/bin/gpauth \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient \
      --replace-fail /usr/bin/gpservice $out/bin/gpservice \
      --replace-fail /opt/homebrew/ $out/ \
      --replace-fail /usr/local/ $out/
  '';

  postInstall = ''
    cp -r packaging/files/usr/libexec $out/libexec
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Upstream links the vendored OpenConnect dylib from Cargo's build directory.
    # Upstream fix: https://github.com/yuezk/GlobalProtect-openconnect/pull/668
    openconnectLibrary=$(otool -L "$out/bin/gpclient" | awk '/\/libopenconnect\..*\.dylib / { print $1 }')
    installedLibrary="$out/lib/$(basename "$openconnectLibrary")"
    install -Dm755 "$openconnectLibrary" "$installedLibrary"
    install_name_tool -id "$installedLibrary" "$installedLibrary"
    install_name_tool -change "$openconnectLibrary" "$installedLibrary" "$out/bin/gpclient"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace $out/libexec/gpclient/vpnc-script \
      --replace-fail /sbin/resolvconf ${openresolv}/bin/resolvconf
  ''
  + lib.optionalString withSystemd ''
    substituteInPlace $out/libexec/gpclient/vpnc-script \
      --replace-fail /usr/bin/resolvectl ${systemd}/bin/resolvectl \
      --replace-fail /usr/bin/busctl ${systemd}/bin/busctl
  ''
  + ''
    wrapProgram "$out/libexec/gpclient/vpnc-script" \
      --prefix PATH : "${
        lib.makeBinPath (
          [
            coreutils
            gawk
            gnugrep
            gnused
            net-tools
            unixtools.ps
          ]
          ++ lib.optionals stdenv.hostPlatform.isLinux [
            iproute2
            openresolv
          ]
        )
      }"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    cp -r packaging/files/usr/lib $out/lib
    substituteInPlace $out/lib/NetworkManager/dispatcher.d/pre-down.d/gpclient.down \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient

    # The dispatcher skips dotfiles, so the .gpclient-nm-hook-wrapped
    # payload next to the wrapper is not run as a second script.
    wrapProgram "$out/lib/NetworkManager/dispatcher.d/gpclient-nm-hook" \
      --prefix PATH : "${
        lib.makeBinPath [
          coreutils
          gnugrep
          unixtools.ps
        ]
      }"

    install -Dm644 packaging/files/usr/share/applications/gpgui.desktop \
      $out/share/applications/gpgui.desktop
    substituteInPlace $out/share/applications/gpgui.desktop \
      --replace-fail /usr/bin/gpclient $out/bin/gpclient
  '';

  postFixup = ''
    # Collectors use GP_COMMAND_PATH instead of PATH.
    wrapProgram "$out/bin/gpclient" \
      --prefix PATH : "${runtimePath}" \
      --prefix GP_COMMAND_PATH : "${runtimePath}" \
      --prefix GIO_EXTRA_MODULES : ${glib-networking}/lib/gio/modules
  '';
})
