{ lib, buildPythonPackage, fetchPypi, isPy27, callPackage
, attrs
, pyrsistent
, six
, functools32
, lockfile
, setuptools_scm
}:

buildPythonPackage rec {
  pname = "jsonschema";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "acc8a90c31d11060516cfd0b414b9f8bcf4bc691b21f0f786ea57dd5255c79db";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    attrs
    pyrsistent
    six
    lockfile
  ] ++ lib.optional isPy27 functools32;

  # tests for latest version rely on custom version of betterpaths that is
  # difficult to deal with and isn't used on master
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/Julian/jsonschema;
    description = "An implementation of JSON Schema validation for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
