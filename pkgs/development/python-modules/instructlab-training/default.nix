{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, pyyaml
, py-cpuinfo
, torch
, transformers
, datasets
, numba
, numpy
, rich
, instructlab-dolomite
, trl
, peft
, pydantic
, aiofiles
 }:

buildPythonPackage rec {
  pname = "instructlab-training";
  version = "0.6.1";
  pyproject = true;

  # TODO: limit to particular python versions?

  src = fetchPypi {
    inherit version;
    pname = "instructlab_training";
    hash = "sha256-b2HZBq6AikeyPTp22hRxwzLyqAQJURxOO7wvH6PO51M=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    pyyaml
    py-cpuinfo
    torch
    transformers
    datasets
    numba
    numpy
    rich
    instructlab-dolomite
    trl
    peft
    pydantic
    aiofiles
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/training/releases/tag/${version}";
    description = "Efficient Fine-Tuning with Message-Format Data";
    homepage = "https://instructlab.ai/";
    license = with licenses; [ asl20 mit ]; # ?
    maintainers = with maintainers; [ booxter ];
  };
}
