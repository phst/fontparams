module("fontparams.data")

params = {
   ScriptPercentScaleDown = {
      type = "int",
      xetex = 10
   },
   ScriptScriptPercentScaleDown = {
      type = "int",
      xetex = 11
   },
   DelimitedSubFormulaMinHeight = {
      xetex = 12
   },
   DisplayOperatorMinHeight = {
      luatex = "Umathoperatorsize",
      xetex = 13
   },
   MathLeading = {
      xetex = 14
   },
   AxisHeight = {
      luatex = "Umathaxis",
      xetex = 15,
      pdftex = 22
   },
   AccentBaseHeight = {
      xetex = 16
   },
   FlattenedAccentBaseHeight = {
      xetex = 17
   },
   SubscriptShiftDown = {
      luatex = "Umathsubshiftdown",
      xetex = 18,
      pdftex = 16
   },
   SubscriptTopMax = {
      luatex = "Umathsubtopmax",
      xetex = 19,
      pdftex = "0.8 abs(sigma(5))"
   },
   SubscriptBaselineDropMin = {
      luatex = "Umathsubshiftdrop",
      xetex = 20,
      pdftex = 19
   },
   SuperscriptShiftUp = {
      luatex = "Umathsupshiftup",
      xetex = {
         cramped = 22,
         noncramped = 21
      },
      pdftex = {
         display = {
            cramped = 15,
            noncramped = 13
         },
         nondisplay = 21
      }
   },
   SuperscriptShiftUpCramped = {
      luatex = "Umathsupshiftup",
      xetex = 22,
      pdftex = {
         display = 15,
         nondisplay = 21
      }
   },
   SuperscriptBottomMin = {
      luatex = "Umathsupbottommin",
      xetex = 23,
      pdftex = {
         number = 5,
         absolute = true,
         factor = 0.25
      }
   },
   SuperscriptBaselineDropMax = {
      luatex = "Umathsupshiftdrop",
      xetex = 24,
      pdftex = 18
   },
   SubSuperscriptGapMin = {
      luatex = "Umathsubsupvgap",
      xetex = 25,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 4
      }
   },
   SuperscriptBottomMaxWithSubscript = {
      luatex = "Umathsupsubbottommax",
      xetex = 26,
      pdftex = {
         number = 5,
         absolute = true,
         factor = 0.8
      }
   },
   SpaceAfterScript = {
      luatex = "Umathspaceafterscript",
      xetex = 27,
      pdftex = "scriptspace"
   },
   UpperLimitGapMin = {
      luatex = "Umathlimitabovevgap",
      xetex = 28,
      pdftex = {
         family = "symbols",
         number = 9
      }
   },
   UpperLimitBaselineRiseMin = {
      luatex = "Umathlimitabovebgap",
      xetex = 29,
      pdftex = {
         family = "symbols",
         number = 11
      }
   },
   LowerLimitGapMin = {
      luatex = "Umathlimitbelowvgap",
      xetex = 30,
      pdftex = {
         family = "symbols",
         number = 10
      }
   },
   LowerLimitBaselineDropMin = {
      luatex = "Umathlimitbelowbgap",
      xetex = 31,
      pdftex = {
         family = "symbols",
         number = 12
      }
   },
   StackTopShiftUp = {
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
      luatex = "Umathstacknumup",
      xetex = 33,
      pdftex = 8
   },
   StackBottomShiftDown = {
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
      luatex = "Umathstackdenomdown",
      xetex = 35,
      pdftex = 11
   },
   StackGapMin = {
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
      luatex = "Umathstackvgap",
      xetex = 37,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 7
      }
   },
   StretchStackTopShiftUp = {
      luatex = "Umathoverdelimiterbgap",
      xetex = 38,
      pdftex = {
         family = "symbols",
         number = 11
      }
   },
   StretchStackBottomShiftDown = {
      luatex = "Umathunderdelimiterbgap",
      xetex = 39,
      pdftex = {
         family = "symbols",
         number = 12
      }
   },
   StretchStackGapAboveMin = {
      luatex = "Umathunderdelimitervgap",
      xetex = 40,
      pdftex = {
         family = "symbols",
         number = 10
      }
   },
   StretchStackGapBelowMin = {
      luatex = "Umathoverdelimitervgap",
      xetex = 41,
      pdftex = {
         family = "symbols",
         number = 9
      }
   },
   FractionNumeratorShiftUp = {
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
      luatex = "Umathfractionnumup",
      xetex = 43,
      pdftex = 8
   },
   FractionDenominatorShiftDown = {
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
      luatex = "Umathfractiondenomdown",
      xetex = 45,
      pdftex = 11
   },
   FractionNumeratorGapMin = {
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
      luatex = "Umathfractionnumvgap",
      xetex = 47,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 3
      }
   },
   FractionRuleThickness = {
      luatex = "Umathfractionrule",
      xetex = 48,
      pdftex = {
         family = "symbols",
         number = 8
      }
   },
   FractionDenominatorGapMin = {
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
      luatex = "Umathfractiondenomvgap",
      xetex = 50,
      pdftex = {
         family = "symbols",
         number = 8,
         factor = 3
      }
   },
   SkewedFractionHorizontalGap = {
      xetex = 51
   },
   SkewedFractionVerticalGap = {
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
      pdftex = "3 xi(8)"
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
      luatex = "Umathradicalvgap",
      xetex = 59,
      pdftex = {
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
      }
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
   FractionDelimiterDisplaySize = {
      luatex = "Umathfractiondelsize",
      pdftex = 20
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
