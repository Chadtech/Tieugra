module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Data.Flags as Flags exposing (Flags)
import Data.Taco as Taco
import Html.Custom exposing (p)
import Html.Styled as Html exposing (Html, div)
import Json.Decode as D exposing (Value)
import Model exposing (Model)
import Msg exposing (Msg(..))
import Page
import Ports exposing (JsMsg(..))
import Return2 as R2
import Route exposing (Route)
import Update
import Url exposing (Url)
import View


-- MAIN --


main : Program Value (Result D.Error Model) Msg
main =
    { init = init
    , onUrlChange = onUrlChange
    , onUrlRequest = UrlRequested
    , subscriptions = subscriptions
    , update = update
    , view = view
    }
        |> Browser.application


onUrlChange : Url -> Msg
onUrlChange =
    Route.fromUrl >> RouteChanged



-- INIT --


init : Value -> Url -> Navigation.Key -> ( Result D.Error Model, Cmd Msg )
init json url key =
    case D.decodeValue Flags.decoder json of
        Ok flags ->
            Model.init json flags key
                |> Update.update (onUrlChange url)
                |> Tuple.mapFirst Ok

        Err err ->
            Err err
                |> R2.withNoCmd



-- UPDATE --


update : Msg -> Result D.Error Model -> ( Result D.Error Model, Cmd Msg )
update msg result =
    case result of
        Ok model ->
            Update.update msg model
                |> Tuple.mapFirst Ok

        Err err ->
            Err err
                |> R2.withNoCmd



-- VIEW --


view : Result D.Error Model -> Browser.Document Msg
view result =
    case result of
        Ok model ->
            View.view model

        Err err ->
            { title = "Error"
            , body =
                err
                    |> D.errorToString
                    |> (++) "An Error occured! : "
                    |> Html.text
                    |> List.singleton
                    |> p []
                    |> List.singleton
                    |> div []
                    |> Html.toUnstyled
                    |> List.singleton
            }



-- SUBSCRIPTIONS --


subscriptions : Result D.Error Model -> Sub Msg
subscriptions result =
    case result of
        Ok model ->
            Ports.fromJs Msg.decode

        Err err ->
            Sub.none
