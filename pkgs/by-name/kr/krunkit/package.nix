{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  asciidoctor,
  buildah,
  buildah-unwrapped,
  cargo,
  libiconv,
  libkrun,
  makeWrapper,
  rustc,
  sigtool,
}:

stdenv.mkDerivation rec {
  pname = "krunkit";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "containers";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oT9/0EonR2GZRAB5fro0rmBZNx3hFszvy6XOqNu+buE=";
  };

  #patches = [
  #  ./dont-call-krun_set_mapped_volumes.patch
  #];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    hash = "sha256-3nQC2bZLXHD1/ugcm30fBv8Cx1xNuC5r0AimXk8LM7M=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    asciidoctor
    makeWrapper
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sigtool ];

  buildInputs =
    [ libkrun ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
    ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postPatch = ''
    # do not pollute etc
    #substituteInPlace src/utils.rs \
    #  --replace "etc/containers" "share/krunkit/containers"
  '';

  env.NIX_LDFLAGS = "-L${libkrun}/lib";

  preBuild = ''
    #find ${libkrun}
    #exit 1
  '';

  postInstall = ''
    mkdir -p $out/share/krunkit/containers
    install -D -m755 ${buildah-unwrapped.src}/docs/samples/registries.conf $out/share/krunkit/containers/registries.conf
    install -D -m755 ${buildah-unwrapped.src}/tests/policy.json $out/share/krunkit/containers/policy.json
  '';

  # It attaches entitlements with codesign and strip removes those,
  # voiding the entitlements and making it non-operational.
  dontStrip = stdenv.hostPlatform.isDarwin;

  postFixup = ''
    wrapProgram $out/bin/krunkit \
      --prefix PATH : ${lib.makeBinPath [ buildah ]} \
  '';

  # TODO: Fix meta!
  meta = with lib; {
    description = "CLI-based utility for creating microVMs from OCI images";
    homepage = "https://github.com/containers/krunkit";
    license = licenses.asl20;
    maintainers = with maintainers; [ nickcao ];
    platforms = libkrun.meta.platforms;
    mainProgram = "krunkit";
  };
}
