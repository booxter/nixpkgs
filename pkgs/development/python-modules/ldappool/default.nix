{ lib, buildPythonPackage, fetchPypi
, pbr, ldap, fixtures, testresources, testtools }:

buildPythonPackage rec {
  name = "ldappool-${version}";
  version = "2.4.1";

  src = fetchPypi {
    pname = "ldappool";
    inherit version;
    sha256 = "23edef09cba4b1ae764f1ddada828d8e39d72cf32a457e599f5a70064310ea00";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ ldap ];

  checkInputs = [ fixtures testresources testtools ];

  meta = with lib; {
    description = "A simple connector pool for python-ldap";
    homepage = https://git.openstack.org/cgit/openstack/ldappool;
    license = licenses.mpl20;
  };
}
