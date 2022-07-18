{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
, click
, requests
, packaging
, dparse
, ruamel-yaml
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "safety";
  version = "2.1.0";

  disabled = pythonOlder "3.6";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YhHUvyKGlO8mKlXljdNXNlC5eYYfQKSdx9U0+PCzObM=";
  };

  postPatch = ''
    substituteInPlace safety/safety.py \
      --replace "telemetry=True" "telemetry=False"
    substituteInPlace safety/cli.py \
      --replace "telemetry', default=True" "telemetry', default=False"
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    setuptools
    click
    requests
    packaging
    dparse
    ruamel-yaml
  ];

  checkInputs = [
    pytestCheckHook
  ];

  # Disable tests depending on online services
  disabledTests = [
    "test_announcements_if_is_not_tty"
    "test_check_live"
    "test_check_live_cached"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Checks installed dependencies for known vulnerabilities";
    homepage = "https://github.com/pyupio/safety";
    changelog = "https://github.com/pyupio/safety/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ thomasdesr dotlambda ];
  };
}
