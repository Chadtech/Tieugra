module Page.Home
    exposing
        ( Model
        , Msg
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
import Return2 as R2
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


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FieldUpdated field str ->
            handleFieldUpdate field str model
                |> R2.withNoCmd

        PostNewThreadClicked ->
            { author = model.newThreadAuthor
            , subject = model.newThreadSubject
            , content =
                model.newThreadContent
                    |> String.split "\n"
            }
                |> Ports.SubmitNewThread
                |> Ports.send
                |> R2.withModel model


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
        [ threadStyle
        , css [ height (px 200) ]
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
    , [ openThreadButton ]
    ]
        |> List.concat
        |> div [ threadStyle ]


threadStyle : Attribute Msg
threadStyle =
    [ Style.border1
    , Style.defaultSpacing
    , backgroundColor Colors.background1
    , displayFlex
    , flexDirection column
    , minHeight (px 100)
    ]
        |> css


postsView : NonEmptyList ( Id, Maybe Post ) -> List (Html Msg)
postsView posts =
    [ [ postView (List.NonEmpty.head posts)
      , br [] []
      ]
    , posts
        |> List.NonEmpty.tail
        |> List.reverse
        |> List.take 2
        |> List.reverse
        |> List.map postView
    ]
        |> List.concat


openThreadButton : Html Msg
openThreadButton =
    button
        [ css [ Style.button ] ]
        [ Html.text "open thread" ]


postView : ( Id, Maybe Post ) -> Html Msg
postView post =
    div
        [ css [ postStyle ] ]
        (postBodyView post)


postBodyView : ( Id, Maybe Post ) -> List (Html Msg)
postBodyView ( id, maybePost ) =
    case maybePost of
        Just post ->
            [ [ p
                    []
                    [ Html.text ("name : " ++ post.author) ]
              , p
                    []
                    [ Html.text ("post : " ++ Id.toString id) ]
              , br [] []
              ]
            , post.content
                |> List.map postSectionView
                |> List.intersperse (br [] [])
            ]
                |> List.concat

        Nothing ->
            [ "post"
            , Id.toString id
            , "not found"
            ]
                |> String.join " "
                |> Html.text
                |> List.singleton
                |> p []
                |> List.singleton


postSectionView : String -> Html Msg
postSectionView paragraph =
    p [] [ Html.text paragraph ]


postStyle : Style
postStyle =
    [ Style.border2
    , Style.defaultSpacing
    , backgroundColor Colors.background2
    , minHeight (px 100)
    ]
        |> Css.batch
