module Page exposing (Page(..))

import Page.Board as Board
import Page.Home as Home
import Page.Thread as Thread


type Page
    = Home Home.Model
    | Board Board.Model
    | Thread Thread.Model
    | Error
    | Blank
