port module Main exposing (..)

import Html.Styled exposing (toUnstyled)
import Json.Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Navigation exposing (Location)
import Page
import Page.Home as Home
import Page.Topic as Topic
import Ports.Mail as Mail exposing (Mail)
import Return2 as R2
import Route exposing (Route)
import View exposing (view)


-- MAIN --


main : Mail.Program Never Model Msg
main =
    Mail.navigationProgram
        onNavigation
        { init = init
        , view = toUnstyled << view
        , update = update
        , subscriptions = subscriptions
        , toJs = toJs
        , fromJs = fromJs
        }


onNavigation : Location -> Msg
onNavigation =
    Route.fromLocation >> RouteChanged


init : Location -> ( Model, Mail Msg )
init location =
    { page = Page.Blank }
        |> update (onNavigation location)



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- UPDATE --


update : Msg -> Model -> ( Model, Mail Msg )
update message model =
    case message of
        RouteChanged (Ok route) ->
            handleRoute route model

        RouteChanged (Err url) ->
            model |> R2.withNoMail

        HomeMsg subMsg ->
            model |> R2.withNoMail

        TopicMsg subMsg ->
            model |> R2.withNoMail


handleRoute : Route -> Model -> ( Model, Mail Msg )
handleRoute route model =
    case route of
        Route.Home ->
            { model
                | page =
                    Page.Home Home.init
            }
                |> R2.withNoMail

        Route.Topic id ->
            { model
                | page =
                    Page.Topic Topic.init
            }
                |> R2.withNoMail



-- PORTS --


port fromJs : (Json.Encode.Value -> msg) -> Sub msg


port toJs : Json.Encode.Value -> Cmd msg
