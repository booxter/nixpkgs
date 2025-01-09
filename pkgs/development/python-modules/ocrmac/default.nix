{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, pyobjc-framework-Vision
, pillow
 }:

buildPythonPackage rec {
  pname = "ocrmac";
  version = "1.0.0";
  pyproject = true;

  # TODO: limit to particular python versions?
  # TODO: limit to mac?

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-WymekDDJc9H2D4LbAA1sLl/ycWAYeMfbCIXoUFl9HS4=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    pyobjc-framework-Vision
    pillow
  ];

  meta = with lib; {
    changelog = "https://github.com/straussmaximilian/ocrmac/releases/tag/v${version}";
    description = "A python wrapper to extract text from images on a mac system. Uses the vision framework from Apple.";
    homepage = "https://github.com/straussmaximilian/ocrmac";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
