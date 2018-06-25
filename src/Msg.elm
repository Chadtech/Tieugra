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
import Json.Decode as Decode
    exposing
        ( Decoder
        , Value
        , decodeValue
        )
import List.NonEmpty exposing (NonEmptyList)
import Page.Home as Home
import Page.Password as Password
import Page.Topic as Topic
import Route exposing (Route)


type Msg
    = RouteChanged (Result String Route)
    | UrlRequested UrlRequest
    | HomeMsg Home.Msg
    | TopicMsg Topic.Msg
    | PasswordMsg Password.Msg
    | ReceivedThread Id Thread
    | ReceivedPost Id Post
    | MsgDecodeFailed Decode.Error


decode : Value -> Msg
decode json =
    case decodeValue decoder json of
        Ok msg ->
            msg

        Err err ->
            MsgDecodeFailed err


decoder : Decoder Msg
decoder =
    Decode.string
        |> Decode.field "type"
        |> Decode.andThen
            (Decode.field "payload" << fromType)


fromType : String -> Decoder Msg
fromType type_ =
    case type_ of
        "received-thread" ->
            Decode.map2 ReceivedThread
                (Decode.field "id" Id.decoder)
                Thread.decoder

        "received-post" ->
            Decode.map2 ReceivedPost
                (Decode.field "id" Id.decoder)
                (Decode.field "post" Post.decoder)

        _ ->
            Decode.fail
                ("Unrecognized incoming msg type -> " ++ type_)
