#!/bin/bash
#
# build-test.sh
# Copyright 2010 Philipp Stephani
#
# This work may be distributed and/or modified under the
# conditions of the LaTeX Project Public License, either version 1.3c
# of this license or (at your option) any later version.
# The latest version of this license is in
#   http://www.latex-project.org/lppl.txt
# and version 1.3c or later is part of all distributions of LaTeX
# version 2009/09/24 or later.
#
# This work has the LPPL maintenance status `maintained'.
# The Current Maintainer of this work is Philipp Stephani.
# This work consists of all files listed in MANIFEST.

set -e

build() {
    program="$1"
    font="$2"
    setup="$3"
    jobname="test-$program-$font"
    command="\\newcommand*{\\FontparamsTestFont}{$font}\\newcommand*{\\FontparamsTestSetup}{$setup}\\input{fontparams-test.tex}"
    "$program" --file-line-error --jobname="$jobname" --interaction=nonstopmode "$command"
}

compare() {
    first_program="$1"
    second_program="$2"
    font="$3"
    first_jobname="test-$first_program-$font"
    second_jobname="test-$second_program-$font"
    echo "Comparing $first_jobname to $second_jobname"
    ./compare-data.py "$first_jobname.dat" "$second_jobname.dat"
}

build pdflatex cm ''
build pdflatex lm '\usepackage{lmodern}'
build pdflatex times '\usepackage{mathptmx}'
build pdflatex pazo '\usepackage{mathpazo}'

build xelatex cm ''
build xelatex cambria '\usepackage{unicode-math}\setmathfont{Cambria Math}'

build lualatex cm ''
build lualatex cambria '\usepackage{unicode-math}\setmathfont{Cambria Math}'

compare pdflatex xelatex cm
compare pdflatex lualatex cm
compare xelatex lualatex cambria

echo 'All tests succeeded.'
