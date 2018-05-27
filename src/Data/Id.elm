module Data.Id
    exposing
        ( Id
        , decoder
        , encode
        , fromString
        , toString
        )

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)


type Id
    = Id String


fromString : String -> Id
fromString =
    Id


toString : Id -> String
toString (Id str) =
    str


decoder : Decoder Id
decoder =
    Decode.map fromString Decode.string


encode : Id -> Value
encode =
    Encode.string << toString
