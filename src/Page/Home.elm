module Page.Home
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Html.Styled as Html exposing (Html)
import Return as R


-- TYPES --


type alias Model =
    ()


type Msg
    = None



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
