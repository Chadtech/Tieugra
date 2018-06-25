module Page.Password
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Colors
import Css exposing (..)
import Data.Taco exposing (Taco)
import Html.Custom exposing (p)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , button
        , div
        , textarea
        )
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onClick, onInput)
import Ports
import Return2 as R2
import Style


-- TYPES --


type alias Model =
    { field : String }


type Msg
    = FieldUpdated String
    | SubmitClicked


init : Model
init =
    { field = "" }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated str ->
            { model | field = str }
                |> R2.withNoCmd

        SubmitClicked ->
            model.field
                |> Ports.SubmitPassword
                |> Ports.send
                |> R2.withModel model



-- VIEW --


view : Taco -> Model -> List (Html Msg)
view taco model =
    div
        [ containerStyle ]
        [ p
            []
            [ Html.text "password" ]
        , passwordField
        , submitPasswordButton
        ]
        |> List.singleton


containerStyle : Attribute Msg
containerStyle =
    [ Style.border1
    , padding (px 5)
    , backgroundColor Colors.background1
    , margin auto
    , width (px 300)
    , marginTop (pct 50)
    ]
        |> css


submitPasswordButton : Html Msg
submitPasswordButton =
    button
        [ submitPasswordButtonSyle
        , onClick SubmitClicked
        ]
        [ Html.text "submit password" ]


submitPasswordButtonSyle : Attribute Msg
submitPasswordButtonSyle =
    [ Style.button
    , width (calc (pct 100) minus (px 10))
    ]
        |> css


passwordField : Html Msg
passwordField =
    textarea
        [ passwordFieldStyle
        , Attrs.spellcheck False
        , onInput FieldUpdated
        ]
        []


passwordFieldStyle : Attribute Msg
passwordFieldStyle =
    [ Style.border1Inset
    , Style.defaultSpacing
    , backgroundColor Colors.background1
    , outline none
    , color Colors.primary0
    , Style.fontSmoothingNone
    , Style.font
    , width (calc (pct 100) minus (px 10))
    ]
        |> css
