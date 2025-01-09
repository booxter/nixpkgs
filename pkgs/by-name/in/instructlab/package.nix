{ lib
, python311Packages
, fetchPypi
# TODO: list all dependencies explicitly?
}:

python311Packages.buildPythonApplication rec {
  pname = "instructlab";
  version = "0.22.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash  = "sha256-LI1n8fQKqTiws8IBn1wrQX6Qm7Dd8M6/npSUf0KAH7U=";
  };

  build-system = with python311Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python311Packages; [
    click
    click-didyoumean
    datasets
    gguf
    gitpython
    httpx
    llama-cpp-python
    openai
    peft
    prompt-toolkit
    pydantic
    pydantic-yaml
    pyyaml
    rich
    rouge-score
    ruamel-yaml
    sentencepiece
    tokenizers
    toml
    torch
    tqdm
    transformers
    trl
    wandb
    xdg-base-dirs
    psutil
    huggingface-hub
    numpy

    instructlab-eval
    instructlab-quantize
    instructlab-schema
    instructlab-sdg
    instructlab-training
  ] ++ lib.optional stdenv.isDarwin [
    mlx
  ];

  pythonRelaxDeps = [
    "mlx"
    "llama-cpp-python"
    "numpy"
    "torch"
  ];

  meta = {
    changelog = "https://github.com/instructlab/instructlab/releases/tag/${version}";
    description = "InstructLab Command-Line Interface";
    homepage = "https://instructlab.ai/";
    license = with lib.licenses; [ asl20 mit ];
    maintainers = with lib.maintainers; [ booxter ];
  };
}
