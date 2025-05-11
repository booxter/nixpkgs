{ lib, stdenv, fetchurl }:

let
in
stdenv.mkDerivation rec {
  pname = "krunvm-bin";
  version = "0.2.3";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/slp/homebrew-krun/refs/heads/master/bottles/krunvm-${version}.arm64_ventura.bottle.tar.gz";
    hash = "sha256-fZV1sGD7Qj0f+yZpboEM4rGk4VmTTP/zdh+2aqHBEe0=";
  };

  installPhase = ''
    runHook preInstall
    for path in bin share; do
      mkdir -p $out/$path
      cp -r ${version}/$path/* $out/$path
    done
    runHook postInstall
  '';

  meta = {
    description = "CLI-based utility for creating microVMs from OCI images, binary version";
    homepage = "https://github.com/slp/homebrew-krun";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
    platforms = lib.platforms.darwin;
    mainProgram = "krunvm";
  };
}
