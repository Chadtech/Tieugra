module Model
    exposing
        ( Model
        , setPage
        , setTaco
        )

import Data.Post exposing (Post)
import Data.Taco exposing (Taco)
import Db exposing (Db)
import Page exposing (Page)


type alias Model =
    { page : Page
    , taco : Taco
    }


setTaco : Model -> Taco -> Model
setTaco model taco =
    { model | taco = taco }


setPage : Model -> (a -> Page) -> a -> Model
setPage model f subModel =
    { model | page = f subModel }
