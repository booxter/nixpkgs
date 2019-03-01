{ stdenv
, buildPythonPackage
, fetchPypi
, libxml2
, libxslt
}:

buildPythonPackage rec {
  pname = "lxml";
  version = "4.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a9d8521c89bf6f2a929c3d12ad3ad7392c774c327ea809fd08a13be6b3bc05f";
  };

  nativeBuildInputs = [ libxml2.dev libxslt.dev ];
  buildInputs = [ libxml2 libxslt ];

  hardeningDisable = stdenv.lib.optional stdenv.isDarwin "format";

  meta = {
    description = "Pythonic binding for the libxml2 and libxslt libraries";
    homepage = https://lxml.de;
    license = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ sjourdois ];
  };
}
