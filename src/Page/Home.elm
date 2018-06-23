module Page.Home
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Css exposing (..)
import Data.Db as Db exposing (Element)
import Data.Post exposing (Post)
import Data.Taco as Taco exposing (Taco)
import Data.Thread exposing (Thread)
import Html.Custom exposing (p)
import Html.Styled as Html
    exposing
        ( Html
        , br
        , button
        , div
        , input
        , textarea
        )
import Html.Styled.Attributes as Attrs exposing (css)
import List.NonEmpty exposing (NonEmptyList)
import Ports exposing (JsMsg(..))
import Return2 as R2
import Util


-- TYPES --


type alias Model =
    { newThreadField : String }


type Msg
    = GetThreadsClicked



-- INIT --


init : Model
init =
    { newThreadField = "" }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetThreadsClicked ->
            model
                |> R2.withCmd
                    (Ports.send GetAllThreads)



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
            [ threadStyle
            , height (px 200)
            ]
        ]
        [ input
            [ css [ newThreadAuthorStyle ]
            , Attrs.spellcheck False
            , Attrs.placeholder "name"
            ]
            []
        , input
            [ css [ newThreadAuthorStyle ]
            , Attrs.spellcheck False
            , Attrs.placeholder "subject"
            ]
            []
        , textarea
            [ css [ newThreadContentStyle ]
            , Attrs.spellcheck False
            , Attrs.placeholder "new thread content.."
            ]
            []
        , button
            [ css [ newThreadButtonStyle ] ]
            [ Html.text "post new thread" ]
        ]


newThreadButtonStyle : Style
newThreadButtonStyle =
    [ Html.Custom.border1
    , backgroundColor Html.Custom.background2
    , margin (px 5)
    , outline none
    , fontFamilies [ "sans-serif" ]
    , color Html.Custom.primary0
    , Html.Custom.fontSmoothingNone
    , fontSize (px 16)
    , hover [ color Html.Custom.primary2 ]
    , active [ Html.Custom.border1Inset ]
    ]
        |> Css.batch


newThreadAuthorStyle : Style
newThreadAuthorStyle =
    [ Html.Custom.border1Inset
    , padding (px 5)
    , margin (px 5)
    , backgroundColor Html.Custom.background1
    , flex2 (int 0) (int 1)
    , outline none
    , fontFamilies [ "sans-serif" ]
    , color Html.Custom.primary0
    , Html.Custom.fontSmoothingNone
    , fontSize (px 16)
    ]
        |> Css.batch


newThreadContentStyle : Style
newThreadContentStyle =
    [ Html.Custom.border1Inset
    , padding (px 5)
    , margin (px 5)
    , backgroundColor Html.Custom.background1
    , flex2 (int 1) (int 1)
    , outline none
    , fontFamilies [ "sans-serif" ]
    , color Html.Custom.primary0
    , Html.Custom.fontSmoothingNone
    , fontSize (px 16)
    ]
        |> Css.batch


threadsView : Taco -> List (Html Msg)
threadsView taco =
    taco
        |> Taco.getThreads
        |> List.repeat 5
        |> List.concat
        |> List.map (threadView taco)


threadView : Taco -> Element Thread -> Html Msg
threadView taco threadElement =
    let
        ( id, thread ) =
            Db.toTuple threadElement
    in
    [ [ p [] [ Html.text thread.title ] ]
    , thread
        |> Taco.getThreadsPosts taco
        |> List.NonEmpty.toList
        |> List.map Db.value
        |> Util.maybeValues
        |> List.map postView
        |> List.take 5
    , [ openThreadButton ]
    ]
        |> List.concat
        |> div [ css [ threadStyle ] ]


openThreadButton : Html Msg
openThreadButton =
    button
        [ css [ newThreadButtonStyle ] ]
        [ Html.text "open thread" ]


threadStyle : Style
threadStyle =
    [ Html.Custom.border1
    , padding (px 5)
    , margin (px 5)
    , backgroundColor Html.Custom.background1
    , displayFlex
    , flexDirection column
    , minHeight (px 100)
    ]
        |> Css.batch


postView : Post -> Html Msg
postView post =
    [ [ p
            []
            [ Html.text ("name : " ++ post.author) ]
      , br [] []
      ]
    , post.content
        |> String.split "  "
        |> List.map postSectionView
        |> List.intersperse (br [] [])
    ]
        |> List.concat
        |> div [ css [ postStyle ] ]


postSectionView : String -> Html Msg
postSectionView paragraph =
    p [] [ Html.text paragraph ]


postStyle : Style
postStyle =
    [ Html.Custom.border2
    , padding (px 5)
    , margin (px 5)
    , backgroundColor Html.Custom.background2
    , minHeight (px 100)
    ]
        |> Css.batch
