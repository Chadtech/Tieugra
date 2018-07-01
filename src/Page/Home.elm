module Page.Home
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Css exposing (..)
import Data.Taco exposing (Taco)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , button
        , div
        , input
        )
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onClick, onInput)
import Id exposing (Id)
import Return2 as R2
import Route
import Style
import Util exposing (onEnter, strReplace)


-- TYPES --


type alias Model =
    { field : String
    }


type Msg
    = FieldUpdated String
    | FieldEnterPressed
    | GoToBoardClicked



-- INIT --


init : Model
init =
    { field = "" }



-- UPDATE --


update : Taco -> Msg -> Model -> ( Model, Cmd Msg )
update taco msg model =
    case msg of
        FieldUpdated str ->
            { model | field = str }
                |> R2.withNoCmd

        FieldEnterPressed ->
            goToBoard taco model

        GoToBoardClicked ->
            goToBoard taco model


goToBoard : Taco -> Model -> ( Model, Cmd Msg )
goToBoard taco model =
    model.field
        |> String.toLower
        |> strReplace "-" " "
        |> Id.fromString
        |> Route.Board
        |> Route.goTo taco
        |> R2.withModel model



-- VIEW --


view : Model -> List (Html Msg)
view model =
    div
        [ css
            [ Style.box
            , minHeight (px 0)
            , maxWidth (px 500)
            , margin2 zero auto
            , marginTop (pct 20)
            ]
        ]
        [ input
            [ css [ Style.input ]
            , Attrs.spellcheck False
            , Attrs.placeholder "board name"
            , Attrs.value model.field
            , onInput FieldUpdated
            , onEnter FieldEnterPressed
            ]
            []
        , button
            [ css [ Style.button ]
            , onClick GoToBoardClicked
            ]
            [ Html.text "go to board" ]
        ]
        |> List.singleton
