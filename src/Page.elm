module Page exposing (Page(..))

import Page.Topic as Topic


type Page
    = Home
    | Topic Topic.Model
    | Error
    | Blank
