{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, jsonschema
, pyyaml
, typing-extensions
, yamllint

# tests
 }:

buildPythonPackage rec {
  pname = "instructlab-schema";
  version = "0.4.2";
  pyproject = true;

  # TODO: limit to particular python versions?

  src = fetchPypi {
    inherit version;
    pname = "instructlab_schema";
    hash = "sha256-AydOlwEnlvbYuleteXq4Li9c3s9OxhY11/jG7/vj0x4=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    jsonschema
    pyyaml
    typing-extensions
    yamllint
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/schema/releases/tag/v${version}";
    description = " JSON schema for Taxonomy YAML";
    homepage = "https://instructlab.ai/";
    license = licenses.asl20;
    maintainers = with maintainers; [ booxter ];
  };
}
