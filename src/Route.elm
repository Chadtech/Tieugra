module Route
    exposing
        ( Route(..)
        , fromUrl
        , toUrl
        )

import Browser.Navigation
import Data.Id as Id exposing (Id)
import Url exposing (Url)
import Url.Parser as Url exposing (Parser, s, top)


type Route
    = Home
    | Topic Id


fromUrl : Url -> Result String Route
fromUrl url =
    Url.parse routeParser url
        |> Result.fromMaybe
            (url.host ++ url.path)


routeParser : Parser (Route -> a) a
routeParser =
    [ Url.map Home top
    , Url.map Topic (Url.custom "ID" (Just << Id.fromString))
    ]
        |> Url.oneOf


toUrl : Route -> String
toUrl route =
    "/" ++ String.join "/" (toPieces route)


toPieces : Route -> List String
toPieces route =
    case route of
        Home ->
            []

        Topic id ->
            [ Id.toString id ]
