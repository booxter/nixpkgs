{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  buildPythonPackage,
  pytestCheckHook,
  setuptools,
  matplotlib,
  numpy,
  packaging,
  torch,
  tqdm,
  flask,
  flask-compress,
  parameterized,
  scikit-learn,
}:

buildPythonPackage rec {
  pname = "captum";
  version = "0.8.0";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "pytorch";
    repo = "captum";
    tag = "v${version}";
    hash = "sha256-WuKbMYZPHWaTYYhVseSSkwXQk9LBzGuWfmneDw9V2hg=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pytorch/captum/pull/1541/commits/1f91e8b44c9aebf76e174a66314527810fced86d.patch";
      hash = "sha256-O/RD3GunmLFSC25aiYJb9MNS6GtQES4cgNfPPzgeKvc=";
    })
    ./tests-use-file-rendezvous.patch
  ];

  dependencies = [
    matplotlib
    numpy
    packaging
    torch
    tqdm
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  pythonImportsCheck = [ "captum" ];

  nativeCheckInputs = [
    pytestCheckHook
    flask
    flask-compress
    parameterized
    scikit-learn
  ];

  disabledTestPaths = lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      # Issue reported upstream at https://github.com/pytorch/captum/issues/1447
      "tests/concept/test_tcav.py"
    ];

  disabledTests = [
    # Failing tests
    "test_softmax_classification_batch_zero_baseline"
    "test_tracin_identity_regression_9_check_idx_none_ArnoldiInfluenceFunction"
  ];

  meta = {
    description = "Model interpretability and understanding for PyTorch";
    homepage = "https://github.com/pytorch/captum";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
