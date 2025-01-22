{
  lib,
  aiohttp,
  buildPythonPackage,
  dill,
  fetchFromGitHub,
  fsspec,
  huggingface-hub,
  multiprocess,
  numpy,
  packaging,
  pandas,
  pyarrow,
  requests,
  tqdm,
  xxhash,
  setuptools-scm,
  filelock,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "datasets";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = pname;
    tag = version;
    hash = "sha256-3Q4tNLA9qUb7XdxP1NftYDcVUgq5ol9OZfklhmadk5I=";
  };

  # remove pyarrow<14.0.1 vulnerability fix
  postPatch = ''
    substituteInPlace src/datasets/features/features.py \
      --replace "import pyarrow_hotfix" "#import pyarrow_hotfix"
  '';

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    aiohttp
    dill
    filelock
    fsspec
    huggingface-hub
    multiprocess
    numpy
    packaging
    pandas
    pyarrow
    pyyaml
    requests
    tqdm
    xxhash
  ] ++ fsspec.optional-dependencies.http;

  pythonRelaxDeps = [
    "dill"
  ];

  # Tests require pervasive internet access
  doCheck = false;

  # Module import will attempt to create a cache directory
  postFixup = "export HF_MODULES_CACHE=$TMPDIR";

  pythonImportsCheck = [ "datasets" ];

  meta = {
    description = "Open-access datasets and evaluation metrics for natural language processing";
    mainProgram = "datasets-cli";
    homepage = "https://github.com/huggingface/datasets";
    changelog = "https://github.com/huggingface/datasets/releases/tag/${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
