#!/usr/bin/env python2.6
#
# compare-data.py
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

from __future__ import (absolute_import, division,
                        unicode_literals, print_function)

import sys
import csv

import numpy


def parse(fname):
    result = {}
    with open(fname, "rt") as stream:
        reader = csv.reader(stream, delimiter=b";")
        for line in reader:
            name = line[0]
            if name.startswith(b"#"):
                continue
            values = line[1:]
            if all(values):
                is_dimen = all(v.endswith(b"pt") for v in values)
                if is_dimen:
                    dimens = [float(v[:-2]) for v in values]
                    result[name] = numpy.array(dimens, float)
                else:
                    numbers = map(int, values)
                    result[name] = numpy.array(numbers, int)
    return result


def compare(name, first, second):
    diff = first - second
    condition = numpy.fabs(diff) > 0.001
    if condition.any():
        print(name, diff)


def main():
    first = parse(sys.argv[1])
    second = parse(sys.argv[2])
    names = frozenset(first).intersection(second)
    for name in names:
        compare(name, first[name], second[name])


if __name__ == "__main__":
    main()
