module View exposing (view)

import Browser
import Html.Styled as Html exposing (Attribute, Html, div)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Error as Error
import Page.Home as Home
import Page.Password as Password
import Page.Topic as Topic


view : Model -> Browser.Document Msg
view model =
    { title = "Argue Chan"
    , body =
        [ div [] (viewBody model)
            |> Html.toUnstyled
        ]
    }


viewBody : Model -> List (Html Msg)
viewBody model =
    case model.page of
        Page.Home subModel ->
            subModel
                |> Home.view model.taco
                |> List.map (Html.map HomeMsg)

        Page.Topic subModel ->
            subModel
                |> Topic.view
                |> List.map (Html.map TopicMsg)

        Page.Password subModel ->
            subModel
                |> Password.view model.taco
                |> List.map (Html.map PasswordMsg)

        Page.Error ->
            Error.view

        Page.Blank ->
            []
