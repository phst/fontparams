-- fontparams-data.lua
-- Copyright 2010, 2011 Philipp Stephani
--
-- This work may be distributed and/or modified under the
-- conditions of the LaTeX Project Public License, either version 1.3c
-- of this license or (at your option) any later version.
-- The latest version of this license is in
--   http://www.latex-project.org/lppl.txt
-- and version 1.3c or later is part of all distributions of LaTeX
-- version 2009/09/24 or later.
--
-- This work has the LPPL maintenance status `maintained'.
-- The Current Maintainer of this work is Philipp Stephani.
-- This work consists of all files listed in MANIFEST.

module("fontparams.data")

params = {
   ScriptPercentScaleDown = {
      description = "A factor used to downscale lengths in top-level subscripts and superscripts, measured in percent",
      type = "int",
      xetex = 10
   },
   ScriptScriptPercentScaleDown = {
      description = "A factor used to downscale lengths in second-level subscripts and superscripts, measured in percent",
      type = "int",
      xetex = 11
   },
   DelimitedSubFormulaMinHeight = {
      description = "Minimum height required for delimited expressions to be treated as a subformula",
      xetex = 12
   },
   DisplayOperatorMinHeight = {
      description = "Minimum size of large operators like summation or integrals in display mode",
      luatex = "Umathoperatorsize",
      xetex = 13
   },
   MathLeading = {
      description = "Minimum leading between mathematical formulas",
      xetex = 14
   },
   AxisHeight = {
      description = "Height of the vertical axis above the baseline",
      luatex = "Umathaxis",
      xetex = 15,
      pdftex = 22
   },
   AccentBaseHeight = {
      description = "Maximum height of accent base characters that does not require raising the accents",
      xetex = 16
   },
   FlattenedAccentBaseHeight = {
      description = "Maximum height of accent base characters that does not require flattening the accents",
      xetex = 17
   },
   SubscriptShiftDown = {
      description = "Standard shift down for subscripts",
      luatex = "Umathsubshiftdown",
      xetex = 18,
      pdftex = 16
   },
   SubscriptTopMax = {
      description = "Maximum baseline distance for the top of subscripts",
      luatex = "Umathsubtopmax",
      xetex = 19,
      pdftex = {
         number = 5,
         absolute = true,
         factor = 0.8
      }
   },
   SubscriptBaselineDropMin = {
      description = "Minimum drop below the baseline of their bases for non-character subscripts",
      luatex = "Umathsubshiftdrop",
      xetex = 20,
      pdftex = 19
   },
   SuperscriptShiftUp = {
      description = "Standard shift up for superscripts",
      luatex = "Umathsupshiftup",
      xetex = {
         cramped = 22,
         noncramped = 21
      },
      pdftex = {
         display = {
            noncramped = 13
         },
         nondisplay = {
            noncramped = 14
         },
         cramped = 15
      }
   },
   SuperscriptShiftUpCramped = {
      only_cramped = true,
      parent = "SuperscriptShiftUp"
   },
   SuperscriptBottomMin = {
      description = "Minimum baseline distance for the bottom of superscripts",
      luatex = "Umathsupbottommin",
      xetex = 23,
      pdftex = {
         number = 5,
         absolute = true,
         factor = 0.25
      }
   },
   SuperscriptBaselineDropMax = {
      description = "Maximum drop below the baseline of their bases for non-character superscripts",
      luatex = "Umathsupshiftdrop",
      xetex = 24,
      pdftex = 18
   },
   SubSuperscriptGapMin = {
      description = "Minimum vertical distance between subscripts and superscripts",
      luatex = "Umathsubsupvgap",
      xetex = 25,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 4
      }
   },
   SuperscriptBottomMaxWithSubscript = {
      description = "Maximum baseline distance for the bottom of superscripts when a subscript is present",
      luatex = "Umathsupsubbottommax",
      xetex = 26,
      pdftex = {
         number = 5,
         absolute = true,
         factor = 0.8
      }
   },
   SpaceAfterScript = {
      description = "Horizontal white space inserted after subscripts and superscripts",
      luatex = "Umathspaceafterscript",
      xetex = 27,
      pdftex = "scriptspace"
   },
   UpperLimitGapMin = {
      description = "Minimum vertical distance between the bottom of an upper limit and the top of its operator",
      luatex = "Umathlimitabovevgap",
      xetex = 28,
      pdftex = {
         family = "symbols",
         number = 9
      }
   },
   UpperLimitBaselineRiseMin = {
      description = "Minimum vertical distance between the baseline of an upper limit and the top of its operator",
      luatex = "Umathlimitabovebgap",
      xetex = 29,
      pdftex = {
         family = "symbols",
         number = 11
      }
   },
   LowerLimitGapMin = {
      description = "Minimum vertical distance between the top of an lower limit and the bottom of its operator",
      luatex = "Umathlimitbelowvgap",
      xetex = 30,
      pdftex = {
         family = "symbols",
         number = 10
      }
   },
   LowerLimitBaselineDropMin = {
      description = "Minimum vertical distance between the baseline of an lower limit and the bottom of its operator",
      luatex = "Umathlimitbelowbgap",
      xetex = 31,
      pdftex = {
         family = "symbols",
         number = 12
      }
   },
   StackTopShiftUp = {
      description = "Standard shift up of the top part of a stack",
      luatex = "Umathstacknumup",
      xetex = {
         display = 33,
         nondisplay = 32
      },
      pdftex = {
         display = 8,
         nondisplay = 10
      }
   },
   StackTopDisplayStyleShiftUp = {
      only_display = true,
      parent = "StackTopShiftUp"
   },
   StackBottomShiftDown = {
      description = "Standard shift down of the bottom part of a stack",
      luatex = "Umathstackdenomdown",
      xetex = {
         display = 35,
         nondisplay = 34
      },
      pdftex = {
         display = 11,
         nondisplay = 12
      }
   },
   StackBottomDisplayStyleShiftDown = {
      only_display = true,
      parent = "StackBottomShiftDown"
   },
   StackGapMin = {
      description = "Minimum vertical distance between the top and bottom elements of a stack",
      luatex = "Umathstackvgap",
      xetex = {
         display = 37,
         nondisplay = 36
      },
      pdftex = {
         family = "symbols",
         number = 8,
         display = {
            factor = 7
         },
         nondisplay = {
            factor = 3
         }
      }
   },
   StackDisplayStyleGapMin = {
      only_display = true,
      parent = "StackGapMin"
   },
   StretchStackTopShiftUp = {
      description = "Standard shift up of the top part of a stretch stack",
      luatex = "Umathoverdelimiterbgap",
      xetex = 38,
      pdftex = {
         family = "symbols",
         number = 11
      }
   },
   StretchStackBottomShiftDown = {
      description = "Standard shift down of the bottom part of a stretch stack",
      luatex = "Umathunderdelimiterbgap",
      xetex = 39,
      pdftex = {
         family = "symbols",
         number = 12
      }
   },
   StretchStackGapAboveMin = {
      description = "Minimum vertical distance between the stretched element and the bottom of the element above in a stretch stack",
      luatex = "Umathunderdelimitervgap",
      xetex = 40,
      pdftex = {
         family = "symbols",
         number = 10
      }
   },
   StretchStackGapBelowMin = {
      description = "Minimum vertical distance between the stretched element and the bottom of the element below in a stretch stack",
      luatex = "Umathoverdelimitervgap",
      xetex = 41,
      pdftex = {
         family = "symbols",
         number = 9
      }
   },
   FractionNumeratorShiftUp = {
      description = "Standard shift up of fraction numerators",
      luatex = "Umathfractionnumup",
      xetex = {
         display = 43,
         nondisplay = 42
      },
      pdftex = {
         display = 8,
         nondisplay = 9
      }
   },
   FractionNumeratorDisplayStyleShiftUp = {
      only_display = true,
      parent = "FractionNumeratorShiftUp"
   },
   FractionDenominatorShiftDown = {
      description = "Standard shift down of fraction denominators",
      luatex = "Umathfractiondenomdown",
      xetex = {
         display = 45,
         nondisplay = 44
      },
      pdftex = {
         display = 11,
         nondisplay = 12
      }
   },
   FractionDenominatorDisplayStyleShiftDown = {
      only_display = true,
      parent = "FractionDenominatorShiftDown"
   },
   FractionNumeratorGapMin = {
      description = "Minimum vertical distance between the bottom of the numerator and the fraction rule",
      luatex = "Umathfractionnumvgap",
      xetex = {
         display = 47,
         nondisplay = 46
      },
      pdftex = {
         family = "symbols",
         number = 8,
         display = {
            factor = 3
         }
      }
   },
   FractionNumDisplayStyleGapMin = {
      only_display = true,
      parent = "FractionNumeratorGapMin"
   },
   FractionRuleThickness = {
      description = "The thickness of the fraction rule",
      luatex = "Umathfractionrule",
      xetex = 48,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   FractionDenominatorGapMin = {
      description = "Minimum vertical distance between the top of the denominator and the fraction rule",
      luatex = "Umathfractiondenomvgap",
      xetex = {
         display = 50,
         nondisplay = 49
      },
      pdftex = {
         family = "symbols",
         number = 8,
         display = {
            factor = 3
         }
      }
   },
   FractionDenomDisplayStyleGapMin = {
      only_display = true,
      parent = "FractionDenominatorGapMin"
   },
   SkewedFractionHorizontalGap = {
      description = "Horizontal distance between top and bottom parts of a skewed fraction",
      xetex = 51
   },
   SkewedFractionVerticalGap = {
      description = "Vertical distance between top and bottom parts of a skewed fraction",
      xetex = 52
   },
   OverbarVerticalGap = {
      luatex = "Umathoverbarvgap",
      xetex = 53,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 3
      }
   },
   OverbarRuleThickness = {
      luatex = "Umathoverbarrule",
      xetex = 54,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   OverbarExtraAscender = {
      luatex = "Umathoverbarkern",
      xetex = 55,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   UnderbarVerticalGap = {
      luatex = "Umathunderbarvgap",
      xetex = 56,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 3
      }
   },
   UnderbarRuleThickness = {
      luatex = "Umathunderbarrule",
      xetex = 57,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   UnderbarExtraDescender = {
      luatex = "Umathunderbarkern",
      xetex = 58,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   RadicalVerticalGap = {
      luatex = "Umathradicalvgap",
      xetex = {
         display = 59,
         nondisplay = 60
      },
      pdftex = {
         display = {
            sum = {
               {
                  family = "symbols",
                  number = 8
               },
               {
                  number = 5,
                  absolute = true,
                  factor = 0.25
               }
            }
         },
         nondisplay = {
            sum = {
               {
                  family = "symbols",
                  number = 8,
               },
               {
                  family = "symbols",
                  number = 8,
                  absolute = true,
                  factor = 0.25
               }
            }
         }
      }
   },
   RadicalDisplayStyleVerticalGap = {
      only_display = true,
      parent = "RadicalVerticalGap"
   },
   RadicalRuleThickness = {
      luatex = "Umathradicalrule",
      xetex = 61
   },
   RadicalExtraAscender = {
      luatex = "Umathradicalkern",
      xetex = 62,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   RadicalKernBeforeDegree = {
      luatex = "Umathradicaldegreebefore",
      xetex = 63
   },
   RadicalKernAfterDegree = {
      luatex = "Umathradicaldegreeafter",
      xetex = 64
   },
   RadicalDegreeBottomRaisePercent = {
      luatex = "Umathradicaldegreeraise",
      xetex = 65
   },
   FractionDelimiterSize = {
      luatex = "Umathfractiondelsize",
      pdftex = {
         display = 20,
         nondisplay = 21
      }
   },
   FractionDelimiterDisplayStyleSize = {
      only_display = true,
      parent = "FractionDelimiterSize"
   },
   {
      luatex = "Umathlimitabovekern",
      pdftex = {
         family = "symbols",
         number = 13
      }
   },
   {
      luatex = "Umathlimitbelowkern",
      pdftex = {
         family = "symbols",
         number = 13
      }
   },
   {
      luatex = "Umathquad",
      pdftex = 6
   },
   SubscriptShiftDownWithSuperscript = {
      luatex = "Umathsubsupshiftdown",
      pdftex = 17
   },
   MinConnectorOverlap = {
      luatex = "Umathconnectoroverlapmin"
   }
}
