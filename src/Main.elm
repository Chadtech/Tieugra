module Main exposing (..)

import Browser
import Browser.Navigation
import Data.Db as Db
import Data.Post as Post
import Data.Taco as Taco
import Json.Decode exposing (Value)
import Json.Encode as Encode
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Home as Home
import Page.Topic as Topic
import Ports exposing (JsMsg(..))
import Return as R
import Route exposing (Route)
import Url exposing (Url)
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
    { page = Page.Blank
    , taco = Taco.empty
    }
        |> update (onNavigation url)



-- SUBSCRIPTIONS --


subscriptions : Model -> Sub Msg
subscriptions model =
    Ports.fromJs Msg.decode



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case Debug.log "MSG" msg of
        RouteChanged (Ok route) ->
            handleRoute route model

        RouteChanged (Err url) ->
            model |> R.withNoCmd

        HomeMsg subMsg ->
            case model.page of
                Page.Home subModel ->
                    subModel
                        |> Home.update subMsg
                        |> R.mapCmd HomeMsg
                        |> R.mapModel
                            (Model.setPage model Page.Home)

                _ ->
                    model
                        |> R.withNoCmd

        TopicMsg subMsg ->
            model |> R.withNoCmd

        ReceivedThread thread ->
            thread
                |> Taco.insertThread model.taco
                |> Model.setTaco model
                |> R.withCmds
                    (List.map Post.get (Db.value thread))

        ReceivedPost post ->
            post
                |> Taco.insertPost model.taco
                |> Model.setTaco model
                |> R.withNoCmd

        MsgDecodeFailed _ ->
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
