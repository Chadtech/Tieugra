module View exposing (view)

import Browser
import Html.Styled as Html exposing (Attribute, Html, div)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Error as Error
import Page.Home as Home
import Page.Topic as Topic


view : Model -> Browser.Page Msg
view model =
    { title = "Argue Chan"
    , body =
        model
            |> viewBody
            |> List.map Html.toUnstyled
    }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.page of
        Page.Home subModel ->
            subModel
                |> Home.view
                |> List.map (Html.map HomeMsg)

        Page.Topic subModel ->
            subModel
                |> Topic.view
                |> List.map (Html.map TopicMsg)

        Page.Error ->
            Error.view

        Page.Blank ->
            []
