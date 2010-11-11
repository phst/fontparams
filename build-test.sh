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

build pdflatex cm ''
build pdflatex lm '\usepackage{lmodern}'
build pdflatex times '\usepackage{mathptmx}'
build pdflatex pazo '\usepackage{mathpazo}'

build xelatex cm ''
build xelatex cambria '\usepackage{unicode-math}\setmathfont{Cambria Math}'

build lualatex cm ''
build lualatex cambria '\usepackage{unicode-math}\setmathfont{Cambria Math}'
