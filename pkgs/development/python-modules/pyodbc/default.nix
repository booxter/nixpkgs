{ stdenv, buildPythonPackage, fetchPypi, isPyPy, unixODBC }:

buildPythonPackage rec {
  pname = "pyodbc";
  version = "4.0.26";
  disabled = isPyPy;  # use pypypdbc instead

  src = fetchPypi {
    inherit pname version;
    sha256 = "e52700b5d24a846483b5ab80acd9153f8e593999c9184ffea11596288fb33de3";
  };

  buildInputs = [ unixODBC ];

  doCheck = false; # tests require a database server

  meta = with stdenv.lib; {
    description = "Python ODBC module to connect to almost any database";
    homepage = "https://github.com/mkleehammer/pyodbc";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
