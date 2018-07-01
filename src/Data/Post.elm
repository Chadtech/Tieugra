module Data.Post
    exposing
        ( Post
        , decoder
        , get
        )

import Id exposing (Id)
import Json.Decode as D exposing (Decoder)
import Ports
import Time exposing (Posix)
import Util


type alias Post =
    { author : String
    , content : List String
    , createdAt : Posix
    }


decoder : Decoder Post
decoder =
    D.map3 Post
        (D.field "author" D.string)
        (D.field "content" (D.list D.string))
        Util.createdAtDecoder


get : Id -> Cmd msg
get =
    Ports.GetPost >> Ports.send
