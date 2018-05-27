module Data.Post
    exposing
        ( Post
        , decoder
        , get
        )

import Data.Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import Ports


type alias Post =
    { author : String
    , content : String
    }


decoder : Decoder Post
decoder =
    Decode.map2 Post
        (Decode.field "author" Decode.string)
        (Decode.field "content" Decode.string)


get : Id -> Cmd msg
get =
    Ports.GetPost >> Ports.send
