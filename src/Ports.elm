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
    = GetPost Id
    | GetAllThreads
    | SubmitPassword String
    | SubmitNewThread NewThreadSubmission


type alias NewThreadSubmission =
    { author : String
    , subject : String
    , content : List String
    , postId : Id
    , threadId : Id
    }


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


withType : String -> Value -> Cmd msg
withType type_ payload =
    withPayload payload type_


send : JsMsg -> Cmd msg
send msg =
    case msg of
        GetPost id ->
            "getPost"
                |> withPayload (Id.encode id)

        GetAllThreads ->
            "getAllThreads"
                |> noPayload

        SubmitPassword str ->
            "submitPassword"
                |> withPayload (E.string str)

        SubmitNewThread submission ->
            [ def "author" (E.string submission.author)
            , def "subject" (E.string submission.subject)
            , def "postId" (Id.encode submission.postId)
            , def "threadId" (Id.encode submission.threadId)
            , submission.content
                |> E.list E.string
                |> def "content"
            ]
                |> E.object
                |> withType "submitNewThread"


port fromJs : (Value -> msg) -> Sub msg


port toJs : Value -> Cmd msg
