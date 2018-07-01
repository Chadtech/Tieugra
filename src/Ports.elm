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
    | GetAllThreads Id
    | SubmitNewThread NewThreadSubmission
    | SubmitNewPost NewPostSubmission


type alias NewThreadSubmission =
    { author : String
    , subject : String
    , content : List String
    , postId : Id
    , threadId : Id
    , boardId : Id
    }


type alias NewPostSubmission =
    { author : String
    , content : List String
    , postId : Id
    , threadId : Id
    , boardId : Id
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

        GetAllThreads boardId ->
            [ def "boardId" <| Id.encode boardId ]
                |> E.object
                |> withType "getAllThreads"

        SubmitNewThread submission ->
            [ def "author" <| E.string submission.author
            , def "subject" <| E.string submission.subject
            , def "postId" <| Id.encode submission.postId
            , def "threadId" <| Id.encode submission.threadId
            , def "boardId" <| Id.encode submission.boardId
            , submission.content
                |> E.list E.string
                |> def "content"
            ]
                |> E.object
                |> withType "submitNewThread"

        SubmitNewPost submission ->
            [ def "author" <| E.string submission.author
            , def "postId" <| Id.encode submission.postId
            , def "threadId" <| Id.encode submission.threadId
            , def "boardId" <| Id.encode submission.boardId
            , submission.content
                |> E.list E.string
                |> def "content"
            ]
                |> E.object
                |> withType "submitNewPost"


port fromJs : (Value -> msg) -> Sub msg


port toJs : Value -> Cmd msg
