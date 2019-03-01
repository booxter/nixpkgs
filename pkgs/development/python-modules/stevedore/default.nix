{ stdenv, buildPythonPackage, fetchPypi, pbr, six }:

buildPythonPackage rec {
  pname = "stevedore";
  version = "1.30.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7be098ff53d87f23d798a7ce7ae5c31f094f3deb92ba18059b1aeb1ca9fec0a0";
  };

  doCheck = false;

  propagatedBuildInputs = [ pbr six ];

  meta = with stdenv.lib; {
    description = "Manage dynamic plugins for Python applications";
    homepage = https://pypi.python.org/pypi/stevedore;
    license = licenses.asl20;
  };
}
