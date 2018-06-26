module Page.Topic
    exposing
        ( Model
        , Msg
        , init
        , update
        , view
        )

import Data.Taco exposing (Taco)
import Html.Styled exposing (Html)
import Id exposing (Id)
import Return2 as R2


-- TYPES --


type alias Model =
    { threadId : Id }


type Msg
    = None


type Reply
    = TopicUpdated



-- INIT --


init : Id -> Model
init id =
    { threadId = id }



-- UPDATE --


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        None ->
            model
                |> R2.withNoCmd



-- VIEW --


view : Taco -> Model -> List (Html Msg)
view taco model =
    []
