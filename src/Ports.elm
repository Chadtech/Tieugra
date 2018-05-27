port module Ports
    exposing
        ( JsMsg(..)
        , fromJs
        , send
        , toJs
        )

import Data.Id as Id exposing (Id)
import Json.Encode as Encode exposing (Value)
import Util exposing (def)


type JsMsg
    = GetAllThreads
    | GetPost Id


noPayload : String -> Cmd msg
noPayload =
    withPayload Encode.null


withPayload : Value -> String -> Cmd msg
withPayload payload type_ =
    [ def "type" <| Encode.string type_
    , def "payload" <| payload
    ]
        |> Encode.object
        |> toJs


send : JsMsg -> Cmd msg
send msg =
    case msg of
        GetAllThreads ->
            "getAllThreads"
                |> noPayload

        GetPost id ->
            "getPost"
                |> withPayload (Id.encode id)


port fromJs : (Value -> msg) -> Sub msg


port toJs : Value -> Cmd msg
