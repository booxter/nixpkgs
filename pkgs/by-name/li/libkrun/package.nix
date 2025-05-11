{
  lib,
  stdenv,
  fixDarwinDylibNames,
  gccStdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo,
  pkg-config,
  glibc,
  linuxHeaders,
  openssl,
  libepoxy,
  libdrm,
  pipewire,
  virglrenderer,
  libkrunfw,
  rustc,
  withBlk ? true,
  withGpu ? false,
  withSound ? false,
  withNet ? false,
  sevVariant ? false,
  efiVariant ? stdenv.hostPlatform.isDarwin,
  llvmPackages_20,
}:

#let
#  stdenv = gccStdenv;
#in
stdenv.mkDerivation (finalAttrs: {
  pname = "libkrun";
  version = "1.11.2";

  src = fetchFromGitHub {
    owner = "containers";
    repo = "libkrun";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B11f7uG/oODwkME2rauCFbVysxUtUrUmd6RKeuBdnUU=";
    #rev = "49c8943364123a6f6fc6cc07eeb6b2c92c792b2a";
    #hash = "sha256-ux08diIZHjsCjF43soUClSluZhKN7de1d7iILbI2nok=";
  };

  patches = [
    #./map-ptr.patch
  ];

  outputs = [
    "out"
    "dev"
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    hash = "sha256-bcHy8AfO9nzSZKoFlEpPKvwupt3eMb+A2rHDaUzO3/U=";
  };

  # Make sure libkrunfw can be found by dlopen()
  # FIXME: This wasn't needed previously. What changed?
  env.RUSTFLAGS = toString (
    map (flag: "-C link-arg=" + flag) [
      #"-Wl,--push-state,--no-as-needed"
      #"-lkrunfw"
      #"-Wl,--pop-state"
    ]
  );

  env.NIX_LDFLAGS = "-L${libkrunfw}/lib";

  postPatch = ''
    #substituteInPlace Makefile \
    #  --replace-fail "gcc -O2 -static -Wall" "${lib.getExe llvmPackages_20.clang} --target=aarch64-linux-gnu -O2 -static -Wall -I${linuxHeaders}/include/linux  -I${linuxHeaders}/include"
    #substituteInPlace src/rutabaga_gfx/src/generated/virgl_renderer_bindings.rs \
    #  --replace-fail 'target_os = "macos"' 'target_os = "linux"'
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    linuxHeaders
    llvmPackages_20.lld
    fixDarwinDylibNames

  ] ++ lib.optional (sevVariant || efiVariant || withGpu) pkg-config;

  buildInputs =
    [
      (libkrunfw.override { inherit sevVariant; })
      #glibc
      #glibc.static
    ]
    ++ lib.optionals (withGpu || efiVariant) [
      libepoxy
      virglrenderer
    ]
    ++ lib.optionals withGpu [
      libdrm
    ]
    ++ lib.optional withSound pipewire
    ++ lib.optional sevVariant openssl;

  makeFlags =
    [
      "PREFIX=${placeholder "out"}"
    ]
    ++ lib.optional withBlk "BLK=1"
    ++ lib.optional withGpu "GPU=1"
    ++ lib.optional withSound "SND=1"
    ++ lib.optional withNet "NET=1"
    ++ lib.optional sevVariant "SEV=1"
    ++ lib.optional efiVariant "EFI=1";

  postInstall = ''
    mkdir -p $dev/lib/pkgconfig
    #mv $out/lib64/pkgconfig $dev/lib/
    mv $out/include $dev/
    #ln -s $out/lib/libkrun-efi.dylib $out/lib/libkrun.dylib
  '';

  meta = with lib; {
    description = "Dynamic library providing Virtualization-based process isolation capabilities";
    homepage = "https://github.com/containers/libkrun";
    license = licenses.asl20;
    maintainers = with maintainers; [
      nickcao
      RossComputerGuy
      nrabulinski
    ];
    platforms = libkrunfw.meta.platforms;
  };
})
