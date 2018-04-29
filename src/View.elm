module View exposing (view)

import Css exposing (..)
import Html.Custom exposing (input, p)
import Html.Styled as Html exposing (Attribute, Html, div)
import Html.Styled.Attributes exposing (css, placeholder, spellcheck, value)
import Html.Styled.Events exposing (onInput)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Util exposing (onEnter)


view : Model -> Html Msg
view model =
    Html.text "Argue Chan!"
