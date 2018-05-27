module Data.Thread
    exposing
        ( decoder
        )

import Data.Db as Db exposing (Element)
import Data.Id as Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)


decoder : Decoder (Element (List Id))
decoder =
    Decode.map2 Db.element
        (Decode.field "id" Id.decoder)
        postIdsDecoder


postIdsDecoder : Decoder (List Id)
postIdsDecoder =
    Id.decoder
        |> Decode.list
        |> Decode.field "posts"
