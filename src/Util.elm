module Util exposing (..)

import Html.Styled exposing (Attribute)
import Html.Styled.Events exposing (keyCode, on)
import Json.Decode as D exposing (Decoder)
import Time exposing (Month(..), Posix, Zone)


-- TUPLE --


def : a -> b -> ( a, b )
def =
    Tuple.pair



-- STRING --


strReplace : String -> String -> String -> String
strReplace src target =
    String.split target >> String.join src



-- DECODERS --


createdAtDecoder : Decoder Posix
createdAtDecoder =
    D.field "createdAt" (D.map Time.millisToPosix D.int)


humanReadableTime : Posix -> String
humanReadableTime time =
    [ Time.toYear germanTimeZone time
    , Time.toMonth germanTimeZone time
        |> monthToInt
    , Time.toDay germanTimeZone time
    ]
        |> List.map String.fromInt
        |> String.join " "


monthToInt : Month -> Int
monthToInt month =
    case month of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12


germanTimeZone : Zone
germanTimeZone =
    Time.customZone 1 []



-- HTML --


onEnter : msg -> Attribute msg
onEnter msg =
    on "keydown"
        (keyCode |> D.andThen (enterDecoder msg))


enterDecoder : msg -> Int -> Decoder msg
enterDecoder msg keyCode =
    case keyCode of
        13 ->
            D.succeed msg

        _ ->
            D.fail "Not enter key"
