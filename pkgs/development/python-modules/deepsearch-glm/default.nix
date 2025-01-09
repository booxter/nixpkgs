{ lib
, pkgs
, buildPythonPackage
, fetchFromGitHub

# build-system
, cmake
, pkg-config
, poetry-core

# dependencies
, setuptools
, cxxopts
, deepsearch-toolkit
, docling-core
, fmt
, loguru-cpp
, matplotlib
, nlohmann_json
, pandas
, pcre2
, pybind11
, python-dotenv
, requests
, rich
, tabulate
, tqdm
, utf8cpp
, zlib
}:

buildPythonPackage rec {
  pname = "deepsearch-glm";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DS4SD";
    repo = "deepsearch-glm";
    tag = "v${version}";
    hash = "sha256-3sJNkrx0tTm6RMYAwV8Aha7x8dZjf4tGdds8OScRff8=";
  };

  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  build-system = [ poetry-core ];

  env = {
    NIX_CFLAGS_COMPILE = "-I${lib.getDev utf8cpp}/include/utf8cpp";
    USE_SYSTEM_DEPS = true;
  };

  cmakeFlags = [
    "-DUSE_SYSTEM_DEPS=True"
  ];

  dependencies = [
    setuptools
    deepsearch-toolkit
    docling-core
    matplotlib
    pandas
    python-dotenv
    requests
    rich
    tabulate
    tqdm
  ];

  # TODO: sort
  buildInputs = [
    #libjpeg
    #qpdf
    zlib
    cxxopts
    pkgs.fasttext
    pkgs.sentencepiece
    fmt
    loguru-cpp
    nlohmann_json
    pcre2
    pybind11
    utf8cpp
  ];

  meta = with lib; {
    changelog = "https://github.com/DS4SD/deepsearch-glm/releases/tag/v${version}";
    description = "Create fast graph language models from converted PDF documents for knowledge extraction and Q&A.";
    homepage = "https://github.com/DS4SD/deepsearch-glm";
    license = licenses.mit;
    maintainers = with maintainers; [ booxter ];
  };
}
