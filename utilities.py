# utilities.py
# Copyright 2011 Philipp Stephani
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

import subprocess

def check_output(*args):
    proc = subprocess.Popen(args, stdout=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    if proc.returncode:
        raise subprocess.CalledProcessError(proc.returncode, args)
    return stdout

def kpsewhich(name):
    stdout = check_output("kpsewhich", name)
    return stdout.rstrip()
