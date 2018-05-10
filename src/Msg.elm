module Msg
    exposing
        ( Msg(..)
        )

import Json.Decode as Decode exposing (Decoder, Value)
import Page.Home as Home
import Page.Topic as Topic
import Route exposing (Route)


type Msg
    = RouteChanged (Result String Route)
    | HomeMsg Home.Msg
    | TopicMsg Topic.Msg
