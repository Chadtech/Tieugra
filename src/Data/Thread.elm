module Data.Thread
    exposing
        ( decoder
        )

import Data.Db as Db exposing (Element)
import Data.Id as Id exposing (Id)
import Json.Decode as Decode exposing (Decoder)
import List.NonEmpty as NonEmpty exposing (NonEmptyList)


decoder : Decoder (Element (NonEmptyList Id))
decoder =
    Decode.map2 Db.element
        (Decode.field "id" Id.decoder)
        postIdsDecoder


postIdsDecoder : Decoder (NonEmptyList Id)
postIdsDecoder =
    Id.decoder
        |> NonEmpty.decoder
        |> Decode.field "posts"
