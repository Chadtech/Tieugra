module Update exposing (update)

import Data.Post as Post
import Data.Taco as Taco exposing (Taco)
import Data.Thread exposing (Thread)
import List.NonEmpty exposing (NonEmptyList)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Page.Board as Board
import Page.Home as Home
import Page.Thread as Thread
import Ports
import Random exposing (Seed)
import Return2 as R2
import Return3 as R3
import Route exposing (Route)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg (( taco, page ) as model) =
    case msg of
        RouteChanged (Ok route) ->
            handleRoute route model

        RouteChanged (Err url) ->
            model |> R2.withNoCmd

        UrlRequested request ->
            model
                |> R2.withNoCmd

        HomeMsg subMsg ->
            case page of
                Page.Home subModel ->
                    subModel
                        |> Home.update taco subMsg
                        |> R2.mapModel Page.Home
                        |> R2.mapModel (Model.setPage model)
                        |> R2.mapCmd HomeMsg

                _ ->
                    model
                        |> R2.withNoCmd

        BoardMsg subMsg ->
            case page of
                Page.Board subModel ->
                    subModel
                        |> Board.update taco subMsg
                        |> R3.mapCmd BoardMsg
                        |> R3.incorp handleBoardReturn model

                _ ->
                    model
                        |> R2.withNoCmd

        ThreadMsg subMsg ->
            case page of
                Page.Thread subModel ->
                    subModel
                        |> Thread.update taco subMsg
                        |> R3.mapCmd ThreadMsg
                        |> R3.incorp handleThreadReturn model

                _ ->
                    model
                        |> R2.withNoCmd

        ReceivedThread boardId threadId thread ->
            taco
                |> Taco.insertThread boardId threadId thread
                |> Model.setTaco model
                |> R2.withCmds (getPostsCmd thread)

        ReceivedPost id post ->
            taco
                |> Taco.insertPost id post
                |> Model.setTaco model
                |> R2.withNoCmd

        MsgDecodeFailed _ ->
            model
                |> R2.withNoCmd


handleBoardReturn : Board.Model -> Maybe Board.Reply -> Model -> ( Model, Cmd Msg )
handleBoardReturn boardModel maybeReply model =
    let
        result =
            boardModel
                |> Page.Board
                |> Model.setPage model
                |> R2.withNoCmd
    in
    case maybeReply of
        Nothing ->
            result

        Just (Board.ThreadSubmitted seed defaultName) ->
            R2.mapModel
                (setNameAndSeed seed defaultName)
                result


handleThreadReturn : Thread.Model -> Maybe Thread.Reply -> Model -> ( Model, Cmd Msg )
handleThreadReturn threadModel maybeReply model =
    let
        result =
            threadModel
                |> Page.Thread
                |> Model.setPage model
                |> R2.withNoCmd
    in
    case maybeReply of
        Nothing ->
            result

        Just (Thread.PostSubmitted seed defaultName) ->
            R2.mapModel
                (setNameAndSeed seed defaultName)
                result


setNameAndSeed : Seed -> String -> Model -> Model
setNameAndSeed seed defaultName =
    (Taco.setSeed seed >> Taco.setDefaultName defaultName)
        |> Model.mapTaco


getPostsCmd : Thread -> List (Cmd Msg)
getPostsCmd { posts } =
    posts
        |> List.NonEmpty.toList
        |> List.map Post.get



-- ROUTING --


handleRoute : Route -> Model -> ( Model, Cmd Msg )
handleRoute route ( taco, page ) =
    case route of
        Route.Home ->
            ( taco, Page.Home Home.init )
                |> R2.withNoCmd

        Route.Board boardId ->
            taco.defaultName
                |> Maybe.withDefault ""
                |> Board.init boardId
                |> Page.Board
                |> Tuple.pair taco
                |> R2.withCmd
                    (Ports.send (Ports.GetAllThreads boardId))

        Route.Thread boardId threadId ->
            { boardId = boardId
            , threadId = threadId
            , defaultName =
                taco.defaultName
                    |> Maybe.withDefault ""
            }
                |> Thread.init
                |> Page.Thread
                |> Tuple.pair taco
                |> R2.withNoCmd
