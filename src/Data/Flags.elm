module Data.Flags
    exposing
        ( Flags
        , decoder
        )

import Json.Decode as D exposing (Decoder)


type alias Flags =
    { apiKeySet : Bool }


decoder : Decoder Flags
decoder =
    D.bool
        |> D.field "apiKey"
        |> D.map Flags
