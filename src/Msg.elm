module Msg
    exposing
        ( Msg(..)
        , decode
        )

import Data.Db as Db exposing (Element)
import Data.Id as Id exposing (Id)
import Data.Post as Post exposing (Post)
import Data.Thread as Thread exposing (Thread)
import Json.Decode as Decode
    exposing
        ( Decoder
        , Value
        , decodeValue
        )
import List.NonEmpty exposing (NonEmptyList)
import Page.Home as Home
import Page.Topic as Topic
import Route exposing (Route)


type Msg
    = RouteChanged (Result String Route)
    | HomeMsg Home.Msg
    | TopicMsg Topic.Msg
    | ReceivedThread (Element Thread)
    | ReceivedPost (Element Post)
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
            Thread.elementDecoder
                |> Decode.map ReceivedThread

        "received-post" ->
            Decode.map2 Db.element
                (Decode.field "id" Id.decoder)
                (Decode.field "post" Post.decoder)
                |> Decode.map ReceivedPost

        _ ->
            Decode.fail
                ("Unrecognized incoming msg type -> " ++ type_)
