{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  setuptools-rust,
  cargo,
  rustPlatform,
  rustc,
  interegular,
  jsonschema,
  pydantic,
  accelerate,
  beartype,
  huggingface-hub,
  torch,
  numpy,
  scipy,
  transformers,
  datasets,
  pillow,
  psutil,
}:

buildPythonPackage rec {
  pname = "outlines-core";
  version = "0.1.27";
  pyproject = true;

  src = fetchPypi {
    pname = "outlines_core";
    inherit version;
    hash = "sha256-WU01xhapCl2h0XJAbIxWuopyGSlkpfUbsBKj1nEO/SI=";
  };

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
    chmod +w Cargo.lock
  '';

  build-system = [
    setuptools-scm
    setuptools-rust
    cargo
    rustPlatform.cargoSetupHook
    rustc
  ];

  dependencies = [
    interegular
    jsonschema
  ];

  pythonImportsCheck = [
    "outlines_core"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pydantic
    accelerate
    beartype
    huggingface-hub
    torch
    numpy
    scipy
    transformers
    datasets
    pillow
    psutil
  ] ++ transformers.optional-dependencies.sentencepiece;

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = {
    description = "Structured generation in Rust";
    changelog = "https://github.com/outlines-dev/outlines/releases/tag/${version}";
    homepage = "https://github.com/outlines-dev/outlines";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
  };
}
