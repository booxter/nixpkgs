{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
 }:

# TODO: mac only?
buildPythonPackage rec {
  pname = "pyobjc-framework-Vision";
  version = "10.3.2";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pyobjc_framework_vision";
    hash = "sha256-XP6kp1BlfiyOfIsMJseqwleLoJq49m/6Di7mMkEMrPM=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
  ];

  meta = with lib; {
    changelog = "https://github.com/ronaldoussoren/pyobjc/releases/tag/v${version}";
    description = "The Python <-> Objective-C Bridge with bindings for macOS frameworks";
    homepage = "https://pyobjc.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
