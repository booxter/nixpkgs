{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, future
 }:

buildPythonPackage rec {
  pname = "word2number";
  version = "1.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-cOJ6XTh/Z7BMcfu3YhwFkwsZv9Ju/WhR5uD5lp3N59A=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    future
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/eval/releases/tag/${version}";
    description = "Convert number words (eg. twenty one) to numeric digits (21)";
    homepage = "http://w2n.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ booxter ];
  };
}
