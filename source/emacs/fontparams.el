;; fontparams.el
;; Copyright 2010, 2011 Philipp Stephani
;;
;; This work may be distributed and/or modified under the
;; conditions of the LaTeX Project Public License, either version 1.3c
;; of this license or (at your option) any later version.
;; The latest version of this license is in
;;   http://www.latex-project.org/lppl.txt
;; and version 1.3c or later is part of all distributions of LaTeX
;; version 2009/09/24 or later.
;;
;; This work has the LPPL maintenance status `maintained'.
;; The Current Maintainer of this work is Philipp Stephani.
;; This work consists of all files listed in MANIFEST.

(TeX-add-style-hook
 "fontparams"
 (function
  (lambda ()
    (TeX-run-style-hooks "expl3" "luatexbase")
    (TeX-add-symbols
     "crampeddisplaystyle"
     "crampedtextstyle"
     "crampedscriptstyle"
     "crampedscriptscriptstyle"
     "ActivateOpenTypeFontParameters"
     "ActivateLegacyFontParameters"
     '("FontParameter" "Name" "Font")
     '("SetFontParameter" "Name" "Font" "Value")
     '("FontParameterByStyle" "Name" "Style")
     '("SetFontParameterByStyle" "Name" "Style" "Value")
     "Umathaxis"
     "Umathconnectoroverlapmin"
     "Umathfractiondelsize"
     "Umathfractiondenomdown"
     "Umathfractiondenomvgap"
     "Umathfractionnumup"
     "Umathfractionnumvgap"
     "Umathfractionrule"
     "Umathlimitabovebgap"
     "Umathlimitabovekern"
     "Umathlimitabovevgap"
     "Umathlimitbelowbgap"
     "Umathlimitbelowkern"
     "Umathlimitbelowvgap"
     "Umathoperatorsize"
     "Umathoverbarkern"
     "Umathoverbarrule"
     "Umathoverbarvgap"
     "Umathoverdelimiterbgap"
     "Umathoverdelimitervgap"
     "Umathquad"
     "Umathradicaldegreeafter"
     "Umathradicaldegreebefore"
     "Umathradicaldegreeraise"
     "Umathradicalkern"
     "Umathradicalrule"
     "Umathradicalvgap"
     "Umathspaceafterscript"
     "Umathstackdenomdown"
     "Umathstacknumup"
     "Umathstackvgap"
     "Umathsubshiftdown"
     "Umathsubshiftdrop"
     "Umathsubsupshiftdown"
     "Umathsubsupvgap"
     "Umathsubtopmax"
     "Umathsupbottommin"
     "Umathsupshiftdrop"
     "Umathsupshiftup"
     "Umathsupsubbottommax"
     "Umathunderbarkern"
     "Umathunderbarrule"
     "Umathunderbarvgap"
     "Umathunderdelimiterbgap"
     "Umathunderdelimitervgap"))))
