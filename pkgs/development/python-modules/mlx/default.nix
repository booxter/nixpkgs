{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  apple-sdk_13,
  blas,
  cmake,
  darwinMinVersionHook,
  lapack,
  nanobind,
  numpy,
  pybind11,
  pytestCheckHook,
  setuptools-scm,
  xcbuild,
  zsh,
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
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "ml-explore";
    repo = "mlx";
    rev = "refs/tags/v${version}";
    hash = "";
  };

  pyproject = true;

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/usr/bin/xcrun" "${xcbuild}/bin/xcrun" \
  '';

  dontUseCmakeConfigure = true;

  # updates the wrong fetcher rev attribute
  passthru.skipBulkUpdate = true;

  env = {
    PYPI_RELEASE = version;
    # we can't use Metal compilation with Darwin SDK
    CMAKE_ARGS = toString [
      (lib.cmakeBool "MLX_BUILD_METAL" false)
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_GGUFLIB" "${gguf-tools}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json}")
      (lib.cmakeOptionType "filepath" "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt}")
    ];
  };

  build-system = [
    cmake
    nanobind
    setuptools-scm
  ];

  nativeBuildInputs = [
    fmt
    gguf-tools
    nlohmann_json
    pybind11
    xcbuild
    zsh
  ];

  buildInputs = [
    blas
    lapack
  ] ++ lib.optionals stdenv.isDarwin [
    # On older SDK versions, build fails with:
    # error: no matching function for call to 'sgeqrf_'
    apple-sdk_13
    (darwinMinVersionHook "13.3")
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  meta = {
    homepage = "https://github.com/ml-explore/mlx";
    description = "Array framework for Apple silicon";
    changelog = "https://github.com/ml-explore/mlx/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = [ "aarch64-darwin" ];
    maintainers = with lib.maintainers; [
      viraptor
      Gabriella439
    ];
  };
}
