module Page.Board
    exposing
        ( Model
        , Msg
        , Reply(..)
        , init
        , update
        , view
        )

import Colors
import Css exposing (..)
import Data.Post exposing (Post)
import Data.Taco as Taco exposing (Taco)
import Data.Thread as Thread exposing (Thread)
import Db
import Html.Custom exposing (p)
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
import List.NonEmpty exposing (NonEmptyList)
import Ports
import Random exposing (Seed)
import Return2 as R2
import Return3 as R3 exposing (Return)
import Route
import Style
import Util


-- TYPES --


type alias Model =
    { newThreadAuthor : String
    , newThreadSubject : String
    , newThreadContent : String
    , id : Id
    }


type Msg
    = FieldUpdated Field String
    | PostNewThreadClicked
    | OpenThreadClicked Id
    | NavItemClicked Id
    | ArgueChanClicked


type Reply
    = ThreadSubmitted Seed String


type Field
    = Author
    | Subject
    | Content



-- INIT --


init : Id -> String -> Model
init id defaultName =
    { newThreadAuthor = defaultName
    , newThreadSubject = ""
    , newThreadContent = ""
    , id = id
    }



-- UPDATE --


update : Taco -> Msg -> Model -> Return Model Msg Reply
update taco msg model =
    case msg of
        FieldUpdated field str ->
            handleFieldUpdate field str model
                |> R3.withNothing

        PostNewThreadClicked ->
            if String.isEmpty model.newThreadContent then
                model
                    |> R3.withNothing
            else
                submitThread taco model

        OpenThreadClicked id ->
            goToThread id taco model

        NavItemClicked id ->
            goToThread id taco model

        ArgueChanClicked ->
            Route.Home
                |> Route.goTo taco
                |> R2.withModel model
                |> R3.withNoReply


goToThread : Id -> Taco -> Model -> Return Model Msg Reply
goToThread id taco model =
    id
        |> Route.Thread model.id
        |> Route.goTo taco
        |> R2.withModel model
        |> R3.withNoReply


submitThread : Taco -> Model -> Return Model Msg Reply
submitThread taco model =
    let
        ( ( threadId, postId ), newSeed ) =
            Random.step
                (Random.pair Id.generator Id.generator)
                taco.seed
    in
    { author = model.newThreadAuthor
    , subject = model.newThreadSubject
    , content =
        model.newThreadContent
            |> String.split "\n"
    , postId = postId
    , threadId = threadId
    , boardId = model.id
    }
        |> Ports.SubmitNewThread
        |> Ports.send
        |> R2.withModel (init model.id model.newThreadAuthor)
        |> R3.withReply (ThreadSubmitted newSeed model.newThreadAuthor)


handleFieldUpdate : Field -> String -> Model -> Model
handleFieldUpdate field str model =
    case field of
        Author ->
            { model | newThreadAuthor = str }

        Subject ->
            { model | newThreadSubject = str }

        Content ->
            { model | newThreadContent = str }



-- VIEW --


view : Taco -> Model -> List (Html Msg)
view taco model =
    let
        threads =
            model.id
                |> Taco.getThreadsOfBoard taco
                |> Thread.sortByCreatedAt
    in
    [ header model.id
    , div
        [ css [ displayFlex ] ]
        [ navView threads
        , bodyView taco model threads
        ]
    ]


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
        ]


navView : List ( Id, Thread ) -> Html Msg
navView threads =
    div
        [ css
            [ Style.box
            , width (px 200)
            ]
        ]
        (List.map navItemView threads)


navItemView : ( Id, Thread ) -> Html Msg
navItemView ( id, thread ) =
    button
        [ css [ Style.button ]
        , onClick (NavItemClicked id)
        ]
        [ Html.text thread.title ]


bodyView : Taco -> Model -> List ( Id, Thread ) -> Html Msg
bodyView taco model threads =
    div
        [ css [ flex (int 1) ] ]
        (newThreadView model :: threadsView taco threads)


newThreadView : Model -> Html Msg
newThreadView model =
    div
        [ css
            [ height (px 200)
            , Style.box
            ]
        ]
        [ threadAuthorView model
        , threadSubjectView
        , newThreadContentView
        , newThreadButtonView
        ]


threadAuthorView : Model -> Html Msg
threadAuthorView model =
    input
        [ css [ Style.input ]
        , Attrs.spellcheck False
        , Attrs.placeholder "name"
        , Attrs.value model.newThreadAuthor
        , onInput (FieldUpdated Author)
        ]
        []


threadSubjectView : Html Msg
threadSubjectView =
    input
        [ css [ Style.input ]
        , Attrs.spellcheck False
        , Attrs.placeholder "subject"
        , onInput (FieldUpdated Subject)
        ]
        []


newThreadContentView : Html Msg
newThreadContentView =
    textarea
        [ css [ Style.textarea ]
        , Attrs.spellcheck False
        , Attrs.placeholder "new thread content.."
        , onInput (FieldUpdated Content)
        ]
        []


newThreadButtonView : Html Msg
newThreadButtonView =
    button
        [ css [ Style.button ]
        , onClick PostNewThreadClicked
        ]
        [ Html.text "submit new thread" ]


threadsView : Taco -> List ( Id, Thread ) -> List (Html Msg)
threadsView taco =
    List.map (threadView taco)


threadView : Taco -> ( Id, Thread ) -> Html Msg
threadView taco ( id, thread ) =
    [ [ p [] [ Html.text thread.title ] ]
    , thread
        |> Taco.getThreadsPosts taco
        |> postsView
    , [ openThreadButton id ]
    ]
        |> List.concat
        |> div [ css [ Style.box ] ]


postsView : NonEmptyList ( Id, Maybe Post ) -> List (Html Msg)
postsView posts =
    [ [ Html.Post.view (List.NonEmpty.head posts)
      , br [] []
      ]
    , posts
        |> List.NonEmpty.tail
        |> List.reverse
        |> List.take 2
        |> List.reverse
        |> List.map Html.Post.view
    ]
        |> List.concat


openThreadButton : Id -> Html Msg
openThreadButton id =
    button
        [ css [ Style.button ]
        , onClick (OpenThreadClicked id)
        ]
        [ Html.text "open thread" ]
