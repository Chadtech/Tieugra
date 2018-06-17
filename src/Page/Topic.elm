module Page.Topic
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Html.Styled exposing (Html)
import Return2 as R2


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
                |> R2.withNoCmd



-- VIEW --


view : Model -> List (Html Msg)
view model =
    []
