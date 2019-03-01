{ lib,
  fetchPypi,
  django,
  buildPythonPackage
}:

buildPythonPackage rec {
  pname = "django-cors-headers";
  version = "2.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f94f96d2cdfa46360c62b892daae42477591997686ebf36c4f1cd9015528d22";
  };

  propagatedBuildInputs = [ django ];

  # pypi release does not include tests
  doCheck = false;

  meta = with lib; {
    description = "Django app for handling server Cross-Origin Resource Sharing (CORS) headers";
    homepage = https://github.com/OttoYiu/django-cors-headers;
    license = licenses.mit;
    maintainers = [ maintainers.ivegotasthma ];
  };
}
