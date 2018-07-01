module Data.Flags
    exposing
        ( Flags
        , decoder
        )

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as JDP
import Random exposing (Seed)


type alias Flags =
    { seed : Seed
    , defaultName : Maybe String
    }


decoder : Decoder Flags
decoder =
    D.succeed Flags
        |> JDP.required "seed" (D.map Random.initialSeed D.int)
        |> JDP.optional "defaultName" (D.map Just D.string) Nothing
