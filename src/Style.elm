module Style exposing (..)

import Colors
import Css exposing (..)


border1 : Style
border1 =
    [ border3 (px 1) outset Colors.primary1
    ]
        |> Css.batch


border1Inset : Style
border1Inset =
    [ border3 (px 1) inset Colors.primary1
    ]
        |> Css.batch


border2 : Style
border2 =
    [ border3 (px 1) outset Colors.primary2
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
    [ fontSize (px 18)
    , fontFamilies [ "serif" ]
    ]
        |> Css.batch


p : Style
p =
    [ color Colors.primary0
    , margin zero
    , font
    ]
        |> Css.batch


headerContainer : Style
headerContainer =
    [ box
    , minHeight maxContent
    , displayFlex
    , flexDirection row
    ]
        |> Css.batch


button : Style
button =
    [ border1
    , backgroundColor Colors.background2
    , defaultSpacing
    , outline none
    , color Colors.primary0
    , font
    , hover [ color Colors.primary2 ]
    , active [ border1Inset ]
    , cursor pointer
    ]
        |> Css.batch


input : Style
input =
    [ border1Inset
    , defaultSpacing
    , backgroundColor Colors.background1
    , flex2 (int 0) (int 1)
    , outline none
    , color Colors.primary0
    , font
    ]
        |> Css.batch


textarea : Style
textarea =
    [ border1Inset
    , defaultSpacing
    , backgroundColor Colors.background1
    , flex2 (int 1) (int 1)
    , outline none
    , color Colors.primary0
    , font
    ]
        |> Css.batch


box : Style
box =
    [ border1
    , defaultSpacing
    , backgroundColor Colors.background1
    , displayFlex
    , flexDirection column
    , minHeight (px 100)
    ]
        |> Css.batch


maxWidth : Style
maxWidth =
    Css.maxWidth (px 1080)
