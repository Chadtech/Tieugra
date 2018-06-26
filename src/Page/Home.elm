module Page.Home
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
    | OpenThread Id


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

        OpenThreadClicked id ->
            model
                |> R2.withNoCmd
                |> R3.withReply (OpenThread id)


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
    [ p [] [ Html.text "Argue Chan" ]
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
        [ newThreadInputStyle
        , Attrs.spellcheck False
        , Attrs.placeholder "name"
        , onInput (FieldUpdated Author)
        ]
        []


threadSubjectView : Html Msg
threadSubjectView =
    input
        [ newThreadInputStyle
        , Attrs.spellcheck False
        , Attrs.placeholder "subject"
        , onInput (FieldUpdated Subject)
        ]
        []


newThreadInputStyle : Attribute Msg
newThreadInputStyle =
    [ Style.border1Inset
    , Style.defaultSpacing
    , backgroundColor Colors.background1
    , flex2 (int 0) (int 1)
    , outline none
    , color Colors.primary0
    , Style.font
    , Style.fontSmoothingNone
    ]
        |> css


newThreadContentView : Html Msg
newThreadContentView =
    textarea
        [ newThreadContentStyle
        , Attrs.spellcheck False
        , Attrs.placeholder "new thread content.."
        , onInput (FieldUpdated Content)
        ]
        []


newThreadContentStyle : Attribute Msg
newThreadContentStyle =
    [ Style.border1Inset
    , Style.defaultSpacing
    , backgroundColor Colors.background1
    , flex2 (int 1) (int 1)
    , outline none
    , color Colors.primary0
    , Style.fontSmoothingNone
    , Style.font
    ]
        |> css


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
