{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "airportsdata";
  version = "20241001";
  pyproject = true;

  # Use github because pypi sdist doesn't include tests
  src = fetchFromGitHub {
    owner = "mborsetti";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-3LKr/9Fin1wVBbx+ZjlFLVYsrnSN8i7WXt3eaug/fwo=";
  };

  build-system = [
    setuptools-scm
  ];

  pythonImportsCheck = [
    "airportsdata"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlags = [ "tests/" "-v" ];

  meta = {
    description = "Extensive database of location and timezone data for nearly every operational airport and landing strip in the world";
    changelog = "https://github.com/mborsetti/airportsdata/releases/tag/v${version}";
    homepage = "https://github.com/mborsetti/airportsdata";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
