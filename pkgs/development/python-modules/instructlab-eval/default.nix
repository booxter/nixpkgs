{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, gitpython
, shortuuid
, openai
, psutil
, torch
, transformers
, accelerate
, pandas
, pandas-stubs
, lm-eval
, httpx
, ragas

# tests
 }:

buildPythonPackage rec {
  pname = "instructlab-eval";
  version = "0.4.2";
  pyproject = true;

  # TODO: limit to particular python versions?

  src = fetchPypi {
    inherit version;
    pname = "instructlab_eval";
    hash = "sha256-dLaK3ZdLfR/oZ8UFWRhCh/UvYwojKz+Wjy51sEaHkO8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    gitpython
    shortuuid
    openai
    psutil
    torch
    transformers
    accelerate
    pandas
    pandas-stubs
    lm-eval
    httpx
    ragas
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/eval/releases/tag/${version}";
    description = "Python Library for Evaluation";
    homepage = "https://instructlab.ai/";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ booxter ];
  };
}
