{ lib
, buildPythonPackage
, fetchPypi
, numpy
, pytestrunner
, pytest
, h5py
}:

buildPythonPackage rec {
  pname = "awkward";
  version = "0.8.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "55cb7bc5c99d27776328a207e7fcf03a072c73438530d16abbc81f246b1b35ec";
  };

  buildInputs = [ pytestrunner h5py ];
  checkInputs = [ pytest ];
  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "Manipulate jagged, chunky, and/or bitmasked arrays as easily as Numpy.";
    homepage = https://github.com/scikit-hep/awkward-array;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
