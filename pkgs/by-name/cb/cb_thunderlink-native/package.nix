{
  lib,
  stdenv,
  fetchFromGitHub,
  python311,
  go_1_22,
}:
let
  darwinApp = fetchFromGitHub {
    owner = "booxter";
    repo = "cb-thunderlink-darwin-handler";
    rev = "93b20bd3f6206417cf22d84f7163aef784c08ca7";
    sha256 = "sha256-H7XO5jtfdiPoHWxNT6xLhUezjcSBPNFVY56EhA5k/c4=";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "cb_thunderlink-native";
  version = "1.7.4";

  src = fetchFromGitHub {
    # owner = "CamielBouchier";
    # repo = "cb_thunderlink";
    # rev = "Release_1_7_4";
    # sha256 = "sha256-Ly4aF4vti18GQSX6/xn3seSwEZm4BV1cXSQjJwBXOKc=";
    owner = "booxter";
    repo = "cb_thunderlink";
    rev = "92df75f71f8db97da8a9a9bda14fea2b8eb01115";
    sha256 = "sha256-uAoOuub9y1IxMogcwGtsIJdcnzDWRrWa3h+KHC5PHOc=";
  };

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    go_1_22
  ];
  buildInputs = [ python311 ];

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -r ${darwinApp} cb-thunderlink-darwin-handler
    pushd cb-thunderlink-darwin-handler
    chmod +w -R .
    export GOCACHE=$(pwd)/.cache
    substituteInPlace main.go --replace-fail 'cb_thunderlink' $out/bin/cb_thunderlink
    ./script/build
    popd
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    install -m 755 cb_thunderlink.py $out/bin/cb_thunderlink

    mkdir -p "$out/lib/mozilla/native-messaging-hosts"
    sed -i -e "s|cb_thunderlink.exe|$out/bin/cb_thunderlink|" "cb_thunderlink.json"

    cp cb_thunderlink.json "$out/lib/mozilla/native-messaging-hosts/"
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r cb-thunderlink-darwin-handler/Thunderlink.app $out/Applications
  '' + ''
    runHook postInstall
  '';

  meta = {
    description =
      "Native messenger for cb_thunderlink, a Thunderbird webextension that implements unique message URIs";
    mainProgram = "cb_thunderlink";
    homepage = "https://camiel.bouchier.be/en/cb_thunderlink";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ booxter ];
  };
})
