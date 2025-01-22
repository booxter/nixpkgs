{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
  interegular,
  jinja2,
  lark,
  nest-asyncio,
  numpy,
  cloudpickle,
  diskcache,
  pydantic,
  referencing,
  jsonschema,
  requests,
  tqdm,
  typing-extensions,
  pycountry,
  airportsdata,
  torch,
  outlines-core,
}:

buildPythonPackage rec {
  pname = "outlines";
  version = "0.1.13";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AjPLP/rpy2sBrY08MrfYfj8c973HsooLyCzT0nfAm8o=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    interegular
    jinja2
    lark
    nest-asyncio
    numpy
    cloudpickle
    diskcache
    pydantic
    referencing
    jsonschema
    requests
    tqdm
    typing-extensions
    pycountry
    airportsdata
    torch
    outlines-core
  ];

  pythonImportsCheck = [
    "outlines"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Structured text generation";
    changelog = "https://github.com/outlines-dev/outlines/releases/tag/${version}";
    homepage = "https://github.com/outlines-dev/outlines";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lach ];
  };
}
