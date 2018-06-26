module Data.Flags
    exposing
        ( Flags
        , decoder
        )

import Json.Decode as D exposing (Decoder)
import Random exposing (Seed)


type alias Flags =
    { apiKeySet : Bool
    , seed : Seed
    }


decoder : Decoder Flags
decoder =
    D.map2 Flags
        (D.field "apiKey" D.bool)
        (D.field "seed" (D.map Random.initialSeed D.int))
