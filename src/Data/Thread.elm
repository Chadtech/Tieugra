module Data.Thread
    exposing
        ( Thread
        , decoder
        , elementDecoder
        )

import Data.Db as Db exposing (Element)
import Data.Id as Id exposing (Id)
import Json.Decode as D exposing (Decoder)
import List.NonEmpty as NonEmpty exposing (NonEmptyList)


type alias Thread =
    { title : String
    , posts : NonEmptyList Id
    }


decoder : Decoder Thread
decoder =
    D.map2 Thread
        (D.field "title" D.string)
        postIdsDecoder


elementDecoder : Decoder (Element Thread)
elementDecoder =
    D.map2 Db.element
        (D.field "id" Id.decoder)
        decoder


postIdsDecoder : Decoder (NonEmptyList Id)
postIdsDecoder =
    Id.decoder
        |> NonEmpty.decoder
        |> D.field "posts"
