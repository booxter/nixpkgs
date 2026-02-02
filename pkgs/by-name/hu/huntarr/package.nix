{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  python3,
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    apprise
    bcrypt
    flask
    markdown
    pillow
    pyotp
    pytz
    pyyaml
    qrcode
    requests
    waitress
  ]);

in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "huntarr";
  version = "9.1.8";

  src = fetchFromGitHub {
    owner = "plexguide";
    repo = "Huntarr.io";
    rev = finalAttrs.version;
    hash = "sha256-WlfiGQSnAPXwX9o/avFNSVywyYRmM2KNYeERHf/0VoE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/huntarr
    cp -R . $out/lib/huntarr

    mkdir -p $out/bin
    makeWrapper ${pythonEnv}/bin/python $out/bin/huntarr \
      --add-flags $out/lib/huntarr/main.py \
      --set PYTHONUNBUFFERED 1

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Find missing media and quality upgrades for *arr apps";
    homepage = "https://github.com/plexguide/Huntarr.io";
    changelog = "https://github.com/plexguide/Huntarr.io/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "huntarr";
    platforms = lib.platforms.unix;
  };
})
