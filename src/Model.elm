module Model exposing (Model)

import Data.Db as Db exposing (Db)
import Data.Post exposing (Post)
import Page exposing (Page)


type alias Model =
    { page : Page
    , threads : Db (List Post)
    }
