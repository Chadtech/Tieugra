module View exposing (view)

import Browser
import Css exposing (..)
import Data.Taco as Taco exposing (Taco)
import Data.Thread exposing (Thread)
import Html.Styled as Html exposing (Attribute, Html, button, div)
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onClick)
import Id exposing (Id)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Board as Board
import Page.Error as Error
import Page.Home as Home
import Page.Thread as Thread
import Style


view : Model -> Browser.Document Msg
view model =
    { title = "Argue Chan"
    , body =
        [ div
            [ css
                [ margin2 zero auto
                , Style.maxWidth
                ]
            ]
            (pageView model)
            |> Html.toUnstyled
        ]
    }


pageView : Model -> List (Html Msg)
pageView ( taco, page ) =
    case page of
        Page.Home subModel ->
            subModel
                |> Home.view
                |> List.map (Html.map HomeMsg)

        Page.Board subModel ->
            subModel
                |> Board.view taco
                |> List.map (Html.map BoardMsg)

        Page.Thread subModel ->
            subModel
                |> Thread.view taco
                |> List.map (Html.map ThreadMsg)

        Page.Error ->
            Error.view

        Page.Blank ->
            []
