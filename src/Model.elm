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
    { page : Page
    , taco : Taco
    }


init : Value -> Flags -> Navigation.Key -> Model
init json flags key =
    { page = Page.Blank
    , taco = Taco.init key flags
    }



-- HELPERS --


mapTaco : (Taco -> Taco) -> Model -> Model
mapTaco f model =
    { model | taco = f model.taco }


setTaco : Model -> Taco -> Model
setTaco model taco =
    { model | taco = taco }


setPage : Model -> (a -> Page) -> a -> Model
setPage model f subModel =
    { model | page = f subModel }
