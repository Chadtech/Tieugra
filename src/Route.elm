module Route
    exposing
        ( Route(..)
        , fromLocation
        , toUrl
        )

import Id exposing (Id)
import Navigation exposing (Location)
import UrlParser as Url exposing (Parser, s)


type Route
    = Home
    | Topic Id


fromLocation : Location -> Result String Route
fromLocation location =
    case Url.parsePath route location of
        Just route ->
            Ok route

        Nothing ->
            (location.origin ++ location.pathname)
                |> Err


route : Parser (Route -> a) a
route =
    [ Url.map Home (s "")
    , Url.map Topic (Url.custom "ID" (Ok << Id.fromString))
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
