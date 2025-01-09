{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, pygments
, tqdm
}:

buildPythonPackage rec {
  pname = "mpire";
  version = "2.10.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9moyHpP63/NFhaS/oF6VvZRs9xS0QvUcUpA460V3PZc=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    pygments
    tqdm
  ];

  meta = with lib; {
    changelog = "https://github.com/sybrenjansen/mpire/releases/tag/v${version}";
    description = "A Python package for easy multiprocessing, but faster than multiprocessing";
    homepage = "https://github.com/sybrenjansen/mpire";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
