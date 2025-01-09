{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, click
, datasets
, docling
, docling-parse
, gguf
, gitpython
, httpx
, instructlab-schema
, langchain-text-splitters
, openai
, sentencepiece
, tabulate
, tenacity
, torch
, transformers
, xdg-base-dirs
 }:

buildPythonPackage rec {
  pname = "instructlab-sdg";
  version = "0.6.3";
  pyproject = true;

  # TODO: limit to particular python versions?

  src = fetchPypi {
    inherit version;
    pname = "instructlab_sdg";
    hash = "sha256-mzOJiy/+irILKpF4heuvy/g2rbFNQ/v/l0CXq5daI94=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    click
    datasets
    docling
    docling-parse
    gguf
    gitpython
    httpx
    instructlab-schema
    langchain-text-splitters
    openai
    sentencepiece
    tabulate
    tenacity
    torch
    transformers
    xdg-base-dirs
  ];

  pythonRelaxDeps = [
    "docling"
    "docling-parse"
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/sdg/releases/tag/v${version}";
    description = " Python library for Synthetic Data Generation";
    homepage = "https://instructlab.ai/";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ booxter ];
  };
}
