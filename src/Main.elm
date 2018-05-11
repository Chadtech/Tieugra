port module Main exposing (..)

import Browser
import Browser.Navigation
import Html.Styled exposing (toUnstyled)
import Json.Decode exposing (Value)
import Json.Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Home as Home
import Page.Topic as Topic
import Return as R
import Route exposing (Route)
import Url.Parser exposing (Url)
import View exposing (view)


-- MAIN --


main : Program Value Model Msg
main =
    { init = init
    , onNavigation = Just onNavigation
    , subscriptions = subscriptions
    , update = update
    , view = view
    }
        |> Browser.fullscreen


onNavigation : Url -> Msg
onNavigation =
    Route.fromUrl >> RouteChanged


init : Browser.Env Value -> ( Model, Cmd Msg )
init { url } =
    { page = Page.Blank }
        |> update (onNavigation url)



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        RouteChanged (Ok route) ->
            handleRoute route model

        RouteChanged (Err url) ->
            model |> R.withNoCmd

        HomeMsg subMsg ->
            model |> R.withNoCmd

        TopicMsg subMsg ->
            model |> R.withNoCmd


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute route model =
    case route of
        Route.Home ->
            { model
                | page =
                    Page.Home Home.init
            }
                |> R.withNoCmd

        Route.Topic id ->
            { model
                | page =
                    Page.Topic Topic.init
            }
                |> R.withNoCmd



-- PORTS --


port fromJs : (Json.Encode.Value -> msg) -> Sub msg


port toJs : Json.Encode.Value -> Cmd msg
