module Util exposing (..)

import Html exposing (Attribute, Html)
import Html.Events exposing (keyCode, on)
import Json.Decode as Decode exposing (Decoder)
import Process
import Task


-- TUPLE --


def : a -> b -> ( a, b )
def =
    Tuple.pair



-- MAYBE --


maybeCons : Maybe a -> List a -> List a
maybeCons maybe list =
    case maybe of
        Just item ->
            item :: list

        Nothing ->
            list



-- LIST --


contains : List a -> a -> Bool
contains list member =
    List.member member list



-- TASK --


delay : Float -> msg -> Cmd msg
delay time msg =
    Process.sleep time
        |> Task.andThen (always <| Task.succeed msg)
        |> Task.perform identity



-- HTML --


onEnter : msg -> Attribute msg
onEnter msg =
    on "keydown" (Decode.andThen (enterDecoder msg) keyCode)


enterDecoder : msg -> Int -> Decoder msg
enterDecoder msg code =
    if code == 13 then
        Decode.succeed msg
    else
        Decode.fail "Not enter"


viewIf : Bool -> Html msg -> Html msg
viewIf condition html =
    if condition then
        html
    else
        Html.text ""
