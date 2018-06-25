port module Ports
    exposing
        ( JsMsg(..)
        , fromJs
        , send
        , toJs
        )

import Id exposing (Id)
import Json.Encode as E exposing (Value)
import Util exposing (def)


type JsMsg
    = GetAllThreads
    | GetPost Id
    | SubmitPassword String


noPayload : String -> Cmd msg
noPayload =
    withPayload E.null


withPayload : Value -> String -> Cmd msg
withPayload payload type_ =
    [ def "type" <| E.string type_
    , def "payload" <| payload
    ]
        |> E.object
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

        SubmitPassword str ->
            "submitPassword"
                |> withPayload (E.string str)


port fromJs : (Value -> msg) -> Sub msg


port toJs : Value -> Cmd msg
