module Page.Home
    exposing
        ( Model
        , Msg
        , Reply(..)
        , init
        , update
        , view
        )

import Browser.Navigation as Navigation
import Colors
import Css exposing (..)
import Data.Post exposing (Post)
import Data.Taco as Taco exposing (Taco)
import Data.Thread exposing (Thread)
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
import Style
import Util


-- TYPES --


type alias Model =
    { newThreadAuthor : String
    , newThreadSubject : String
    , newThreadContent : String
    }


type Msg
    = FieldUpdated Field String
    | PostNewThreadClicked
    | OpenThreadClicked Id


type Reply
    = NewSeed Seed


type Field
    = Author
    | Subject
    | Content



-- INIT --


init : Model
init =
    { newThreadAuthor = ""
    , newThreadSubject = ""
    , newThreadContent = ""
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
            model
                |> R2.withCmd (goToThread taco id)
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
    }
        |> Ports.SubmitNewThread
        |> Ports.send
        |> R2.withModel model
        |> R3.withReply (NewSeed newSeed)


goToThread : Taco -> Id -> Cmd Msg
goToThread { navigationKey } id =
    Navigation.pushUrl navigationKey (Id.toString id)


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
    [ Html.Custom.argueChanTitle
    , newThreadView
    ]
        ++ threadsView taco


newThreadView : Html Msg
newThreadView =
    div
        [ css
            [ height (px 200)
            , Style.thread
            ]
        ]
        [ threadAuthorView
        , threadSubjectView
        , newThreadContentView
        , newThreadButtonView
        ]


threadAuthorView : Html Msg
threadAuthorView =
    input
        [ css [ Style.input ]
        , Attrs.spellcheck False
        , Attrs.placeholder "name"
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
        [ Html.text "post new thread" ]


threadsView : Taco -> List (Html Msg)
threadsView taco =
    taco
        |> Taco.getThreads
        |> List.map (threadView taco)


threadView : Taco -> ( Id, Thread ) -> Html Msg
threadView taco ( id, thread ) =
    [ [ p [] [ Html.text thread.title ] ]
    , thread
        |> Taco.getThreadsPosts taco
        |> postsView
    , [ openThreadButton id ]
    ]
        |> List.concat
        |> div [ css [ Style.thread ] ]


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
