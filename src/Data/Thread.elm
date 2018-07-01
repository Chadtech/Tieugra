module Data.Thread
    exposing
        ( Thread
        , decoder
        , sortByCreatedAt
        )

import Db
import Id exposing (Id)
import Json.Decode as D exposing (Decoder)
import List.NonEmpty as NonEmpty exposing (NonEmptyList)
import Time exposing (Posix)
import Util


type alias Thread =
    { title : String
    , posts : NonEmptyList Id
    , createdAt : Posix
    }



-- DECODER --


decoder : Decoder Thread
decoder =
    D.map3 Thread
        (D.field "title" D.string)
        postIdsDecoder
        Util.createdAtDecoder


postIdsDecoder : Decoder (NonEmptyList Id)
postIdsDecoder =
    Id.decoder
        |> NonEmpty.decoder
        |> D.field "posts"



-- HELPERS --


sortByCreatedAt : List ( Id, Thread ) -> List ( Id, Thread )
sortByCreatedAt =
    List.sortBy
        (Tuple.second >> .createdAt >> Time.posixToMillis)
        >> List.reverse
