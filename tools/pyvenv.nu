#!/usr/bin/env nu

## Activates the python environment in a sub-sub-shell
# defaults to ./venv
# deactivate by exiting
## if command is given after virtual environment location
# after the command ends, the virtualenv exits
def main [path="./venv" ...command] {
  if (0 < ($command | length)) {
    sh -i -c $"source ($path)/bin/activate ; nu -c ($command | str join ' '); exit 0"
  } else {
    sh -i -c $"source ($path)/bin/activate ; nu"
  }
}
