module Page.Topic
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Css exposing (..)
import Data.Taco as Taco exposing (Taco)
import Data.Thread exposing (Thread)
import Html.Custom
import Html.Post
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , br
        , button
        , div
        , input
        , textarea
        )
import Html.Styled.Attributes as Attrs exposing (css)
import Html.Styled.Events exposing (onClick, onInput)
import Id exposing (Id)
import List.NonEmpty
import Random
import Return2 as R2
import Return3 as R3 exposing (Return)
import Style


-- TYPES --


type alias Model =
    { threadId : Id
    , newPostContent : String
    , newPostAuthor : String
    }


type Msg
    = FieldUpdated Field String
    | PostNewPostClicked


type Field
    = Author
    | Content


type Reply
    = NewSeed



-- INIT --


init : Id -> Model
init id =
    { threadId = id
    , newPostContent = ""
    , newPostAuthor = ""
    }



-- UPDATE --


update : Taco -> Msg -> Model -> Return Model Msg Reply
update taco msg model =
    case msg of
        FieldUpdated field str ->
            handleFieldUpdate field str model
                |> R3.withNothing

        PostNewPostClicked ->
            if String.isEmpty model.newPostContent then
                model
                    |> R3.withNothing
            else
                submitPost taco model


submitPost : Taco -> Model -> Return Model Msg Reply
submitPost taco model =
    let
        ( threadId, newSeed ) =
            Random.step Id.generator taco.seed
    in
    model
        |> R3.withNothing


handleFieldUpdate : Field -> String -> Model -> Model
handleFieldUpdate field str model =
    case field of
        Author ->
            { model | newPostAuthor = str }

        Content ->
            { model | newPostContent = str }



-- VIEW --


view : Taco -> Model -> List (Html Msg)
view taco model =
    [ Html.Custom.argueChanTitle
    , newPostView
    ]
        ++ postsView taco model


newPostView : Html Msg
newPostView =
    div
        [ css
            [ height (px 200)
            , Style.thread
            ]
        ]
        [ postAuthorView
        , newPostContentView
        , newPostButtonView
        ]


postAuthorView : Html Msg
postAuthorView =
    input
        [ css [ Style.input ]
        , Attrs.spellcheck False
        , Attrs.placeholder "name"
        , onInput (FieldUpdated Author)
        ]
        []


newPostContentView : Html Msg
newPostContentView =
    textarea
        [ css [ Style.textarea ]
        , Attrs.spellcheck False
        , Attrs.placeholder "new post content.."
        , onInput (FieldUpdated Content)
        ]
        []


newPostButtonView : Html Msg
newPostButtonView =
    button
        [ css [ Style.button ]
        , onClick PostNewPostClicked
        ]
        [ Html.text "post new thread" ]


postsView : Taco -> Model -> List (Html Msg)
postsView taco model =
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
