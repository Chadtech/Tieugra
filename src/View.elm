module View exposing (view)

import Html.Styled as Html exposing (Attribute, Html, div)
import Model exposing (Model)
import Msg exposing (Msg(HomeMsg, TopicMsg))
import Page
import Page.Error as Error
import Page.Home as Home
import Page.Topic as Topic


view : Model -> Html Msg
view model =
    case model.page of
        Page.Home subModel ->
            subModel
                |> Home.view
                |> Html.map HomeMsg

        Page.Topic subModel ->
            subModel
                |> Topic.view
                |> Html.map TopicMsg

        Page.Error ->
            Error.view

        Page.Blank ->
            Html.text ""
