{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
, accelerate
, datasets
, dill
, evaluate
, jsonlines
, more-itertools
, numexpr
, peft
, pybind11
, pytablewriter
, rouge-score
, sacrebleu
, scikit-learn
, sqlitedict
, torch
, tqdm-multiprocess
, transformers
, word2number
, zstandard
 }:

buildPythonPackage rec {
  pname = "lm-eval";
  version = "0.4.7";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "lm_eval";
    hash = "sha256-3L74ci82P1jPuja214P8a7F5JLJLjaFoS/Gsg1hmII0=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
    accelerate
    datasets
    dill
    evaluate
    jsonlines
    more-itertools
    numexpr
    peft
    pybind11
    pytablewriter
    rouge-score
    sacrebleu
    scikit-learn
    sqlitedict
    torch
    tqdm-multiprocess
    transformers
    word2number
    zstandard
  ];

  meta = with lib; {
    changelog = "https://github.com/EleutherAI/lm-evaluation-harness/releases/tag/v${version}";
    description = " A framework for few-shot evaluation of language models.";
    homepage = "https://github.com/EleutherAI/lm-evaluation-harness";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
