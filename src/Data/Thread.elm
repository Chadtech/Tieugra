module Data.Thread
    exposing
        ( Thread
        , decoder
        )

import Db
import Id exposing (Id)
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


postIdsDecoder : Decoder (NonEmptyList Id)
postIdsDecoder =
    Id.decoder
        |> NonEmpty.decoder
        |> D.field "posts"
