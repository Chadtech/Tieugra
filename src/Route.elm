module Route
    exposing
        ( Route(..)
        , fromUrl
        , goTo
        , toUrl
        )

import Browser.Navigation as Navigation
import Data.Taco exposing (Taco)
import Id exposing (Id)
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), Parser, s, top)


type Route
    = Home
    | Board Id
    | Thread Id Id


fromUrl : Url -> Result String Route
fromUrl url =
    Url.parse routeParser url
        |> Result.fromMaybe
            (url.host ++ url.path)


routeParser : Parser (Route -> a) a
routeParser =
    [ Url.map Home top
    , Url.map Board id
    , Url.map Thread (id </> id)
    ]
        |> Url.oneOf


id : Parser (Id -> b) b
id =
    Url.custom "ID" (Just << Id.fromString)


toUrl : Route -> String
toUrl route =
    "/" ++ String.join "/" (toPieces route)


toPieces : Route -> List String
toPieces route =
    case route of
        Home ->
            []

        Board boardId ->
            [ Id.toString boardId ]

        Thread boardId threadId ->
            [ Id.toString boardId
            , Id.toString threadId
            ]


goTo : Taco -> Route -> Cmd msg
goTo { navigationKey } route =
    toUrl route
        |> Navigation.pushUrl navigationKey
