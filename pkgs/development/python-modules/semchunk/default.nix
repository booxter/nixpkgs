{ lib
, buildPythonPackage
, fetchPypi

# build-system
, hatchling

# dependencies
, setuptools
, tqdm
, mpire
 }:

buildPythonPackage rec {
  pname = "semchunk";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UP9nHLHGYNZm5eXHfNufDYhd9pPvrmp3HcVUFAjcAZw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    setuptools
    tqdm
    mpire
  ];

  meta = with lib; {
    changelog = "https://github.com/umarbutler/semchunk/releases/tag/v${version}";
    description = "A fast, lightweight and easy-to-use Python library for splitting text into semantically meaningful chunks.";
    homepage = "https://github.com/umarbutler/semchunk";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
