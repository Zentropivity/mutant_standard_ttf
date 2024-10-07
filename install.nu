#!/usr/bin/nu

cp -r -f ./mutant_standard/manifest/license /usr/share/licenses/ttf-mutant-standard
mkdir /usr/share/fonts/mutant-standard
cp -f ./out/build/MutantStandard-*.ttf /usr/share/fonts/mutant-standard/
