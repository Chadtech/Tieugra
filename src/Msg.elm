module Msg
    exposing
        ( Msg(..)
        , decode
        )

import Browser exposing (UrlRequest)
import Data.Post as Post exposing (Post)
import Data.Thread as Thread exposing (Thread)
import Db
import Id exposing (Id)
import Json.Decode as D
    exposing
        ( Decoder
        , Value
        , decodeValue
        )
import List.NonEmpty exposing (NonEmptyList)
import Page.Board as Board
import Page.Home as Home
import Page.Thread
import Route exposing (Route)


type Msg
    = RouteChanged (Result String Route)
    | UrlRequested UrlRequest
    | BoardMsg Board.Msg
    | ThreadMsg Page.Thread.Msg
    | HomeMsg Home.Msg
    | ReceivedThread Id Id Thread
    | ReceivedPost Id Post
    | MsgDecodeFailed String


decode : Value -> Msg
decode json =
    case decodeValue decoder json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed (D.errorToString err)


decoder : Decoder Msg
decoder =
    D.string
        |> D.field "type"
        |> D.andThen
            (D.field "payload" << fromType)


fromType : String -> Decoder Msg
fromType type_ =
    case type_ of
        "received-thread" ->
            D.map3 ReceivedThread
                (D.at [ "thread", "boardId" ] Id.decoder)
                (D.field "id" Id.decoder)
                (D.field "thread" Thread.decoder)

        "received-post" ->
            D.map2 ReceivedPost
                (D.field "id" Id.decoder)
                (D.field "post" Post.decoder)

        _ ->
            D.fail
                ("Unrecognized incoming msg type -> " ++ type_)
