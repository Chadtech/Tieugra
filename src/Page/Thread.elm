module Page.Thread
    exposing
        ( Model
        , Msg
        , Reply(..)
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
import Ports
import Random exposing (Seed)
import Return2 as R2
import Return3 as R3 exposing (Return)
import Route
import Style


-- TYPES --


type alias Model =
    { threadId : Id
    , boardId : Id
    , newPostContent : String
    , newPostAuthor : String
    }


type Msg
    = FieldUpdated Field String
    | PostNewPostClicked
    | ArgueChanClicked
    | BoardClicked Id


type Field
    = Author
    | Content


type Reply
    = PostSubmitted Seed String


type alias Flags =
    { boardId : Id
    , threadId : Id
    , defaultName : String
    }



-- INIT --


init : Flags -> Model
init { boardId, threadId, defaultName } =
    { threadId = threadId
    , boardId = boardId
    , newPostContent = ""
    , newPostAuthor = defaultName
    }


reInit : Model -> Model
reInit model =
    { model | newPostContent = "" }



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

        ArgueChanClicked ->
            Route.Home
                |> Route.goTo taco
                |> R2.withModel model
                |> R3.withNoReply

        BoardClicked id ->
            id
                |> Route.Board
                |> Route.goTo taco
                |> R2.withModel model
                |> R3.withNoReply


submitPost : Taco -> Model -> Return Model Msg Reply
submitPost taco model =
    let
        ( postId, newSeed ) =
            Random.step Id.generator taco.seed
    in
    { author = model.newPostAuthor
    , content =
        model.newPostContent
            |> String.split "\n"
    , postId = postId
    , threadId = model.threadId
    , boardId = model.boardId
    }
        |> Ports.SubmitNewPost
        |> Ports.send
        |> R2.withModel (reInit model)
        |> R3.withReply (PostSubmitted newSeed model.newPostAuthor)


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
    model
        |> postsView taco
        |> (::) (newPostView model)
        |> (::) (header model.boardId)



-- Header --


header : Id -> Html Msg
header id =
    div
        [ css [ Style.headerContainer ] ]
        [ button
            [ css
                [ Style.button
                , flex (int 1)
                ]
            , onClick ArgueChanClicked
            ]
            [ Html.text "Argue Chan" ]
        , button
            [ css
                [ Style.button
                , flex (int 1)
                ]
            , onClick (BoardClicked id)
            ]
            [ Html.text (Id.toString id) ]
        ]



-- New Post --


newPostView : Model -> Html Msg
newPostView model =
    div
        [ css
            [ height (px 200)
            , Style.box
            ]
        ]
        [ postAuthorView model
        , newPostContentView
        , newPostButtonView
        ]


postAuthorView : Model -> Html Msg
postAuthorView model =
    input
        [ css [ Style.input ]
        , Attrs.spellcheck False
        , Attrs.placeholder "name"
        , Attrs.value model.newPostAuthor
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
        [ Html.text "submit new post" ]



-- Thread content --


postsView : Taco -> Model -> List (Html Msg)
postsView taco model =
    model.threadId
        |> Taco.getThread taco
        |> maybeThreadView taco
        |> div [ css [ Style.box ] ]
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
