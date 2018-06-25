module Page exposing (Page(..))

import Page.Home as Home
import Page.Password as Password
import Page.Topic as Topic


type Page
    = Home Home.Model
    | Topic Topic.Model
    | Password Password.Model
    | Error
    | Blank
