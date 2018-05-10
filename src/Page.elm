module Page exposing (Page(..))

import Page.Home as Home
import Page.Topic as Topic


type Page
    = Home Home.Model
    | Topic Topic.Model
    | Error
    | Blank
