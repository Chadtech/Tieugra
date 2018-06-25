module Style exposing (..)

import Colors
import Css exposing (..)


border1 : Style
border1 =
    [ border3 (px 1) outset Colors.primary1
    , borderRadius (px 5)
    ]
        |> Css.batch


border1Inset : Style
border1Inset =
    [ border3 (px 1) inset Colors.primary1
    , borderRadius (px 5)
    ]
        |> Css.batch


border2 : Style
border2 =
    [ border3 (px 1) outset Colors.primary2
    , borderRadius (px 5)
    ]
        |> Css.batch


defaultSpacing : Style
defaultSpacing =
    [ margin (px 5)
    , padding (px 5)
    ]
        |> Css.batch


font : Style
font =
    [ fontSize (px 16)
    , fontFamilies [ "sans-serif" ]
    ]
        |> Css.batch


p : Style
p =
    [ fontFamilies [ "sans-serif" ]
    , color Colors.primary0
    , margin zero
    , fontSmoothingNone
    ]
        |> Css.batch


button : Style
button =
    [ border1
    , backgroundColor Colors.background2
    , defaultSpacing
    , outline none
    , color Colors.primary0
    , fontSmoothingNone
    , font
    , hover [ color Colors.primary2 ]
    , active [ border1Inset ]
    ]
        |> Css.batch


fontSmoothingNone : Style
fontSmoothingNone =
    property "-webkit-font-smoothing" "none"
