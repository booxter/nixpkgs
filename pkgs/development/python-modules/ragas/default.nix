{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, appdirs
, datasets
, diskcache
, langchain
, langchain-community
, langchain-core
, langchain-openai
, nest-asyncio
, numpy
, openai
, pydantic
, pysbd
, tiktoken
 }:

buildPythonPackage rec {
  pname = "ragas";
  version = "0.2.10";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-SASrs2IvR6igTwn0cVff+pQ8L43ZnEg6fLxa5v9WLac=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    appdirs
    datasets
    diskcache
    langchain
    langchain-community
    langchain-core
    langchain-openai
    nest-asyncio
    numpy
    openai
    pydantic
    pysbd
    tiktoken

    # TODO: add optional deps?
  ];

  meta = with lib; {
    changelog = "https://github.com/explodinggradients/ragas/releases/tag/v${version}";
    description = "Ragas is your ultimate toolkit for evaluating and optimizing Large Language Model (LLM) applications";
    homepage = "https://docs.ragas.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ booxter ];
  };
}
