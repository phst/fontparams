#!/bin/bash

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
