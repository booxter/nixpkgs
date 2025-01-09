{ lib
, buildPythonPackage
, fetchPypi

# build-system
, setuptools-scm

# dependencies
, setuptools
 }:

buildPythonPackage rec {
  pname = "instructlab-quantize";
  version = "0.1.0";
  pyproject = true;

  # TODO: limit to particular python versions?

  src = fetchPypi {
    inherit version;
    pname = "instructlab_quantize";
    hash = "sha256-hmYSfi/vLe8xnmkLUVa7jABsgkaye1FG+Fj3JdLDJQA=";
  };

  build-system = [
    setuptools-scm
  ];

  dependencies = [
    setuptools
  ];

  meta = with lib; {
    changelog = "https://github.com/instructlab/instructlab-quantize/releases/tag/v${version}";
    description = "llama.cpp's quantize program for macOS and Linux";
    homepage = "https://instructlab.ai/";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ booxter ];
  };
}
