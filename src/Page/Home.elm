module Page.Home
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Data.Db as Db
import Data.Taco as Taco exposing (Taco)
import Html exposing (Html, button)
import Html.Attributes as Attrs
import Html.Events exposing (onClick)
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
    [ button
        [ onClick GetThreadsClicked ]
        [ Html.text "get threads" ]
    ]
