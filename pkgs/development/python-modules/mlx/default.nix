{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  pybind11,
  cmake,
  xcbuild,
  zsh,
  blas,
  lapack,
  setuptools,
  nanobind,
  apple-sdk_15,
}:

let
  # static dependencies included directly during compilation
  gguf-tools = fetchFromGitHub {
    owner = "antirez";
    repo = "gguf-tools";
    rev = "af7d88d808a7608a33723fba067036202910acb3";
    hash = "sha256-LqNvnUbmq0iziD9VP5OTJCSIy+y/hp5lKCUV7RtKTvM=";
  };
  nlohmann_json = fetchFromGitHub {
    owner = "nlohmann";
    repo = "json";
    rev = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
  fmt = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    rev = "11.1.1";
    hash = "sha256-nNFKGB8a399KPsMI/zLVTxgFvIxnaTHVFbOfd9ClQeo=";
  };
in
buildPythonPackage rec {
  pname = "mlx";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    rev = "refs/tags/v${version}";
    hash = "sha256-uw8Nq26XoyMGNO8lEEAAO1e8Jt2SLg+CWfGZh829nxk=";
  };

  pyproject = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/usr/bin/xcrun" "${xcbuild}/bin/xcrun" \
  '';

  dontUseCmakeConfigure = true;

  env = {
    PYPI_RELEASE = version;
    CMAKE_ARGS = toString [
      # we can't use Metal compilation because metal tool only ships with Xcode
      (lib.cmakeBool "MLX_BUILD_METAL" false)
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt}")
    ];
  };

  nativeBuildInputs = [
    cmake
    pybind11
    xcbuild
    zsh
    gguf-tools
    fmt
    nlohmann_json
    setuptools
  ];

  buildInputs = [
    blas
    lapack
    nanobind
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_15 ];

  meta = with lib; {
    homepage = "https://github.com/ml-explore/mlx";
    description = "Array framework for Apple silicon";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = licenses.mit;
    platforms = [ "aarch64-darwin" ];
    maintainers = with maintainers; [
      viraptor
      Gabriella439
    ];
  };
}
