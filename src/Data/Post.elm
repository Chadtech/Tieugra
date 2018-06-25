module Data.Post
    exposing
        ( Post
        , decoder
        , get
        )

import Id exposing (Id)
import Json.Decode as D exposing (Decoder)
import Ports


type alias Post =
    { author : String
    , content : List String
    }


decoder : Decoder Post
decoder =
    D.map2 Post
        (D.field "author" D.string)
        (D.field "content" (D.list D.string))


get : Id -> Cmd msg
get =
    Ports.GetPost >> Ports.send
