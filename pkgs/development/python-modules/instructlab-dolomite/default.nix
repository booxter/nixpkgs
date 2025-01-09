{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, torch
, transformers
, safetensors
 }:

buildPythonPackage rec {
  pname = "instructlab-dolomite";
  version = "0.2.0";
  pyproject = true;

  # TODO: limit to particular python versions?

  src = fetchPypi {
    inherit version;
    pname = "instructlab_dolomite";
    hash = "sha256-Pe7wkTUhD44RWNk4NeAKYyaU1/G6oNn7o9WmutOgwj4=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    torch
    transformers
    safetensors
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/GPTDolomite/releases/tag/v${version}";
    description = "Code for IBM models packaged for InstructLab consumption";
    homepage = "https://instructlab.ai/";
    license = licenses.asl20;
    maintainers = with maintainers; [ booxter ];
  };
}
