{ lib
, buildPythonPackage
, fetchPypi

# build-system
, poetry-core

# dependencies
, setuptools
, beautifulsoup4
, certifi
, deepsearch-glm
, docling-core
, docling-ibm-models
, docling-parse
, easyocr
, filetype
, huggingface-hub
, lxml
, marko
# , ocrmac # TODO: mac only?
, onnxruntime
, openpyxl
, pandas
, pydantic
, pydantic-settings
, pypdfium2
, python-docx
, python-pptx
, rapidocr-onnxruntime
, requests
, rtree
, scipy
, tesserocr
, typer
 }:

buildPythonPackage rec {
  pname = "docling";
  version = "2.15.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V4tOs8mDPpUCWqpBdMDzobkDfIGnX8YW5JwWr70her8=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    setuptools
    beautifulsoup4 certifi
    deepsearch-glm
    docling-core
    docling-ibm-models
    docling-parse
    easyocr
    filetype
    huggingface-hub
    lxml
    marko
    # ocrmac
    onnxruntime
    openpyxl
    pandas
    pydantic
    pydantic-settings
    pypdfium2
    python-docx
    python-pptx
    rapidocr-onnxruntime
    requests
    rtree
    scipy
    tesserocr
    typer
  ];

  meta = with lib; {
    changelog = "https://github.com/DS4SD/docling/releases/tag/v${version}";
    description = "Get your documents ready for gen AI";
    homepage = "https://ds4sd.github.io/docling";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
