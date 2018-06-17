module Html.Custom
    exposing
        ( background0
        , background1
        , background2
        , border1
        , border1Inset
        , border2
        , fontSmoothingNone
        , input
        , p
        , pStyle
        , primary0
        , primary2
        , red
        )

import Css exposing (..)
import Html.Styled as Html exposing (Attribute, Html)
import Html.Styled.Attributes exposing (css)


border1 : Style
border1 =
    [ border3 (px 1) outset primary1
    , borderRadius (px 5)
    ]
        |> Css.batch


border1Inset : Style
border1Inset =
    [ border3 (px 1) inset primary1
    , borderRadius (px 5)
    ]
        |> Css.batch


border2 : Style
border2 =
    [ border3 (px 1) outset primary2
    , borderRadius (px 5)
    ]
        |> Css.batch


input : List (Attribute msg) -> List (Html msg) -> Html msg
input attrs =
    Html.input (inputCss :: attrs)


inputCss : Attribute msg
inputCss =
    [ fontFamilies [ "Arial" ]

    --, color black
    , fontSize (em 2)

    --, backgroundColor white1
    , border3 (px 2) solid lightGray
    , outline none
    , width (px 500)
    ]
        |> css


p : List (Attribute msg) -> List (Html msg) -> Html msg
p attrs =
    Html.p (css pStyle :: attrs)


pStyle : List Style
pStyle =
    [ fontFamilies [ "sans-serif" ]
    , color primary0
    , margin zero
    , fontSmoothingNone
    ]


fontSmoothingNone : Style
fontSmoothingNone =
    property "-webkit-font-smoothing" "none"



-- COLORS --


background0 : Color
background0 =
    hex "#060003"


background1 : Color
background1 =
    hex "#160812"


background2 : Color
background2 =
    hex "#241720"


primary0 : Color
primary0 =
    hex "#d0aca4"


primary1 : Color
primary1 =
    hex "#c09488"


primary2 : Color
primary2 =
    hex "#b08074"


lightGray : Color
lightGray =
    hex "#d0b5a9"


red : Color
red =
    hex "#803030"
