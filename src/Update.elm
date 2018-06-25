module Update exposing (update)

import Data.Post as Post
import Data.Taco as Taco
import Data.Thread as Thread exposing (Thread)
import List.NonEmpty exposing (NonEmptyList)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Home as Home
import Page.Password as Password
import Page.Topic as Topic
import Return2 as R2
import Route exposing (Route)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RouteChanged (Ok route) ->
            handleRoute route model

        UrlRequested request ->
            let
                _ =
                    Debug.log "Request" request
            in
            model
                |> R2.withNoCmd

        RouteChanged (Err url) ->
            model |> R2.withNoCmd

        HomeMsg subMsg ->
            case model.page of
                Page.Home subModel ->
                    subModel
                        |> Home.update subMsg
                        |> R2.mapCmd HomeMsg
                        |> R2.mapModel
                            (Model.setPage model Page.Home)

                _ ->
                    model
                        |> R2.withNoCmd

        TopicMsg subMsg ->
            model |> R2.withNoCmd

        PasswordMsg subMsg ->
            case model.page of
                Page.Password subModel ->
                    subModel
                        |> Password.update subMsg
                        |> R2.mapCmd PasswordMsg
                        |> R2.mapModel
                            (Model.setPage model Page.Password)

                _ ->
                    model
                        |> R2.withNoCmd

        ReceivedThread id thread ->
            model.taco
                |> Taco.insertThread id thread
                |> Model.setTaco model
                |> R2.withCmds (getPostsCmd thread)

        ReceivedPost id post ->
            model.taco
                |> Taco.insertPost id post
                |> Model.setTaco model
                |> R2.withNoCmd

        MsgDecodeFailed _ ->
            model
                |> R2.withNoCmd


getPostsCmd : Thread -> List (Cmd Msg)
getPostsCmd { posts } =
    posts
        |> List.NonEmpty.toList
        |> List.map Post.get


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute route model =
    case route of
        Route.Home ->
            { model
                | page =
                    Page.Home Home.init
            }
                |> maybeRedirectToPassword

        Route.Topic id ->
            { model
                | page =
                    Page.Topic Topic.init
            }
                |> maybeRedirectToPassword


maybeRedirectToPassword : Model -> ( Model, Cmd Msg )
maybeRedirectToPassword model =
    if model.taco.apiKeySet then
        model
            |> R2.withNoCmd
    else
        { model
            | page =
                Page.Password Password.init
        }
            |> R2.withNoCmd
