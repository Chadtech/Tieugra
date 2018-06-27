module Page.Topic
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Data.Taco as Taco exposing (Taco)
import Data.Thread exposing (Thread)
import Html.Post
import Html.Styled exposing (Html, div)
import Html.Styled.Attributes exposing (css)
import Id exposing (Id)
import List.NonEmpty
import Return2 as R2
import Style


-- TYPES --


type alias Model =
    { threadId : Id }


type Msg
    = None


type Reply
    = TopicUpdated



-- INIT --


init : Id -> Model
init id =
    { threadId = id }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            model
                |> R2.withNoCmd



-- VIEW --


view : Taco -> Model -> List (Html Msg)
view taco model =
    model.threadId
        |> Taco.getThread taco
        |> maybeThreadView taco
        |> div [ css [ Style.thread ] ]
        |> List.singleton


maybeThreadView : Taco -> ( Id, Maybe Thread ) -> List (Html Msg)
maybeThreadView taco ( threadId, maybeThread ) =
    case maybeThread of
        Just thread ->
            threadView taco threadId thread

        Nothing ->
            missingThreadView


threadView : Taco -> Id -> Thread -> List (Html Msg)
threadView taco threadId thread =
    thread.posts
        |> List.NonEmpty.toList
        |> Taco.getPosts taco
        |> List.map Html.Post.view


missingThreadView : List (Html Msg)
missingThreadView =
    []
