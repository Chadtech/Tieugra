module Model
    exposing
        ( Model
        , init
        , mapTaco
        , setPage
        , setTaco
        )

import Browser.Navigation as Navigation
import Data.Flags exposing (Flags)
import Data.Post exposing (Post)
import Data.Taco as Taco exposing (Taco)
import Db exposing (Db)
import Json.Decode as D exposing (Value)
import Page exposing (Page)


type alias Model =
    ( Taco, Page )


init : Value -> Flags -> Navigation.Key -> Model
init json flags key =
    ( Taco.init key flags, Page.Blank )



-- HELPERS --


mapTaco : (Taco -> Taco) -> Model -> Model
mapTaco f =
    Tuple.mapFirst f


setTaco : Model -> Taco -> Model
setTaco ( _, page ) newTaco =
    ( newTaco, page )


setPage : Model -> Page -> Model
setPage ( taco, _ ) newPage =
    ( taco, newPage )
