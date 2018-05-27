module Page.Topic
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Html exposing (Html)
import Return as R


-- TYPES --


type alias Model =
    ()


type Msg
    = None


type Reply
    = TopicUpdated



-- INIT --


init : Model
init =
    ()



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            model
                |> R.withNoCmd



-- VIEW --


view : Model -> List (Html Msg)
view model =
    []
