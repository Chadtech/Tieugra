module Data.Db
    exposing
        ( Db
        , Element
        , empty
        , getElement
        , getValue
        , id
        , insert
        , remove
        , toDb
        , toElement
        , toTuple
        , value
        , values
        )

import Data.Id as Id exposing (Id)
import Dict


-- Database --


type Db a
    = Db (Dict.Dict String a)


insert : Element item -> Db item -> Db item
insert (Element thisId item) (Db dict) =
    Dict.insert (Id.toString thisId) item dict
        |> Db


remove : Id -> Db item -> Db item
remove thisId (Db dict) =
    Db (Dict.remove (Id.toString thisId) dict)


getValue : Id -> Db item -> Maybe item
getValue thisId (Db dict) =
    Dict.get (Id.toString thisId) dict


getElement : Id -> Db item -> Maybe (Element item)
getElement thisId db =
    getValue thisId db
        |> Maybe.map (toElement thisId)


values : Db item -> List item
values (Db dict) =
    Dict.values dict


toDb : List (Element item) -> Db item
toDb items =
    items
        |> List.map toTuple
        |> List.map (Tuple.mapFirst Id.toString)
        |> Dict.fromList
        |> Db


empty : Db item
empty =
    Db Dict.empty



-- Element --


type Element v
    = Element Id v


id : Element v -> Id
id (Element thisId _) =
    thisId


value : Element v -> v
value (Element _ item) =
    item


toElement : Id -> v -> Element v
toElement =
    Element


toTuple : Element v -> ( Id, v )
toTuple (Element thisId v) =
    ( thisId, v )
