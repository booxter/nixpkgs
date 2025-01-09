{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools
, setuptools-scm

# dependencies
, accelerate
, datasets
, rich
, transformers
 }:

buildPythonPackage rec {
  pname = "trl";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rTJZCYRXuSqU+V3m2kE4gHyEaRm+rMzyLSasI4mHtQs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    accelerate
    datasets
    rich
    transformers
  ];

  meta = {
    changelog = "https://github.com/huggingface/trl/releases/tag/${version}";
    description = " Train transformer language models with reinforcement learning.";
    homepage = "https://huggingface.co/docs/trl/index";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
  };
}
