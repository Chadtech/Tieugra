module Data.Db
    exposing
        ( Db
        , Element
        , element
        , empty
        , getElement
        , getValue
        , id
        , insert
        , insertMany
        , mapElement
        , remove
        , toDb
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


insertMany : List (Element item) -> Db item -> Db item
insertMany elements db =
    List.foldr insert db elements


remove : Id -> Db item -> Db item
remove thisId (Db dict) =
    Db (Dict.remove (Id.toString thisId) dict)


getValue : Db item -> Id -> Maybe item
getValue (Db dict) thisId =
    Dict.get (Id.toString thisId) dict


getElement : Db item -> Id -> Element (Maybe item)
getElement db thisId =
    getValue db thisId
        |> element thisId


values : Db item -> List (Element item)
values (Db dict) =
    Dict.toList dict
        |> List.map
            (Tuple.mapFirst Id.fromString >> fromPair)


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


element : Id -> v -> Element v
element =
    Element


mapElement : (v -> w) -> Element v -> Element w
mapElement f (Element thisId item) =
    Element thisId (f item)


fromPair : ( Id, v ) -> Element v
fromPair ( thisId, v ) =
    element thisId v


toTuple : Element v -> ( Id, v )
toTuple (Element thisId v) =
    ( thisId, v )
