module List.NonEmpty
    exposing
        ( NonEmptyList
        , decoder
        , head
        , map
        , toList
        )

import Json.Decode as Decode exposing (Decoder)


type NonEmptyList a
    = NonEmptyList a (List a)


head : NonEmptyList a -> a
head (NonEmptyList first _) =
    first


map : (a -> b) -> NonEmptyList a -> NonEmptyList b
map f (NonEmptyList item list) =
    NonEmptyList (f item) (List.map f list)


toList : NonEmptyList a -> List a
toList (NonEmptyList item list) =
    item :: list


decoder : Decoder a -> Decoder (NonEmptyList a)
decoder itemDecoder =
    itemDecoder
        |> Decode.list
        |> Decode.andThen toNonEmptyListDecoder


toNonEmptyListDecoder : List a -> Decoder (NonEmptyList a)
toNonEmptyListDecoder list =
    case list of
        [] ->
            Decode.fail "list is empty"

        first :: rest ->
            NonEmptyList first rest
                |> Decode.succeed
