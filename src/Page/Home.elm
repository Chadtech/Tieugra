module Page.Home
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Data.Db as Db exposing (Element)
import Data.Post exposing (Post)
import Data.Taco as Taco exposing (Taco)
import Html exposing (Html, button, div, p)
import Html.Attributes as Attrs
import Html.Events exposing (onClick)
import List.NonEmpty exposing (NonEmptyList)
import Ports exposing (JsMsg(..))
import Return as R


-- TYPES --


type alias Model =
    ()


type Msg
    = GetThreadsClicked



-- INIT --


init : Model
init =
    ()



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GetThreadsClicked ->
            model
                |> R.withCmd
                    (Ports.send GetAllThreads)



-- VIEW --


view : Taco -> Model -> List (Html Msg)
view taco model =
    [ p []
        [ Html.text "Argue Chan" ]
    ]
        ++ threadsView taco


threadsView : Taco -> List (Html Msg)
threadsView taco =
    taco
        |> Taco.getThreads
        |> List.map threadView


threadView : Element (NonEmptyList (Element (Maybe Post))) -> Html Msg
threadView thread =
    div
        []
        (postsView (Db.value thread))


postsView : NonEmptyList (Element (Maybe Post)) -> List (Html Msg)
postsView =
    List.map postView << List.NonEmpty.toList


postView : Element (Maybe Post) -> Html Msg
postView maybePost =
    case Db.value maybePost of
        Nothing ->
            p [] [ Html.text "NO POST" ]

        Just post ->
            p
                []
                [ Html.text post.content
                ]
