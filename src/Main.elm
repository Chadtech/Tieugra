module Main exposing (..)

import Html.Styled exposing (toUnstyled)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Page
import Page.Topic as Topic
import Ports exposing (JsMsg(ConsoleLog, Square))
import Return2 exposing (withCmds, withNoCmd)
import Route exposing (Route)
import View exposing (view)


-- MAIN --


main : Program Never Model Msg
main =
    Navigation.program
        onNavigation
        { init = init
        , view = toUnstyled << view
        , update = update
        , subscriptions = subscriptions
        }


onNavigation : Location -> Msg
onNavigation =
    Route.fromLocation >> RouteChanged


init : Location -> ( Model, Cmd Msg )
init location =
    { page = Page.Blank }
        |> update (onNavigation location)



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Ports.fromJs Msg.decode



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        RouteChanged (Ok route) ->
            handleRoute route model

        RouteChanged (Err url) ->
            model |> withNoCmd

        MsgDecodeFailed _ ->
            model |> withNoCmd


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute route model =
    case route of
        Route.Home ->
            { model | page = Page.Home }
                |> withNoCmd

        Route.Topic id ->
            { model
                | page =
                    Page.Topic Topic.init
            }
                |> withNoCmd
