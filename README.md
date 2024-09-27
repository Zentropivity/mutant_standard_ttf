# Build Mutant Standard as TTF font

Why? Because its a great emoji font! I want to see them all over my desktop.

## How?

First you need to make sure the required tools are installed:

- `nushell` (probably could have made it without, but I like to script using it `¯\_(ツ)_/¯`)
- `python` (and its virtualenv/venv and pip)
- `git` of course

0. Make sure you have the submodules. Either clone this repo with `--recursive` or do `git submodule update --init`
1. Create a python virtual environment and activate it, like: `python -m venv venv` then source the activation file for your shell (for nushell just run `./pyvenv`)
2. Run `./build_ttf.nu`  
   this produces the font file in `out/build/MutantStandard-Regular.ttf`
3. On linux, you could also copy the font and its license to the system fonts by running `sudo ./install.nu`

## License

Everything in this repository is licensed under a MIT license, except the materials used under the repositories in the following folders have their own licensing:

- `mutant_standard`: Mutant Standard emoji are licensed CC BY-NC-SA 4.0 International
- `orxporter`: Orxporter is licensed under the Cooperative Non-Violent License (CNPL) v4
- `nanoemoji`: nanoemoji is licensed under the Apache-2.0 license

## Your contributions

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the MIT license, shall be licensed as above, without any additional terms or conditions.
