{ lib, buildPythonPackage, fetchPypi, isPy27, futures, mock, pytest }:

buildPythonPackage rec {
  pname = "isort";
  version = "4.3.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f19b23b22fb5a919a081bc31aabcc0991614c244d9215267e11abf2ca7b684ce";
  };

  propagatedBuildInputs = lib.optional isPy27 futures;

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test_isort.py -k "not test_long_line_comments \
                          and not test_import_case_produces_inconsistent_results_issue_472 \
                          and not test_no_extra_lines_issue_557 \
                          and not test_command_line and not test_safety_excludes and not test_other_file_encodings and not test_new_lines_are_preserved"
  '';

  meta = with lib; {
    description = "A Python utility / library to sort Python imports";
    homepage = https://github.com/timothycrosley/isort;
    license = licenses.mit;
    maintainers = with maintainers; [ couchemar nand0p ];
  };
}
