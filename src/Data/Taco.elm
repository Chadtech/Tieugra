module Data.Taco
    exposing
        ( Taco
        , empty
        , getThreads
        , insertPost
        , insertThread
        )

import Data.Db as Db exposing (Db, Element)
import Data.Id exposing (Id)
import Data.Post exposing (Post)
import List.NonEmpty exposing (NonEmptyList)


type alias Taco =
    { threads : Db (NonEmptyList Id)
    , posts : Db Post
    }


empty : Taco
empty =
    { threads = Db.empty
    , posts = Db.empty
    }


insertThread : Taco -> Element (NonEmptyList Id) -> Taco
insertThread taco thread =
    { taco
        | threads =
            Db.insert thread taco.threads
    }


insertPost : Taco -> Element Post -> Taco
insertPost taco post =
    { taco
        | posts =
            Db.insert post taco.posts
    }


getThreads : Taco -> List (Element (NonEmptyList (Element (Maybe Post))))
getThreads taco =
    taco.threads
        |> Db.values
        |> List.map
            (Db.mapElement (getThreadsPosts taco))


getThreadsPosts : Taco -> NonEmptyList Id -> NonEmptyList (Element (Maybe Post))
getThreadsPosts taco =
    List.NonEmpty.map (getPost taco)


getPosts : Taco -> List Id -> List (Element (Maybe Post))
getPosts taco =
    List.map (getPost taco)


getPost : Taco -> Id -> Element (Maybe Post)
getPost taco id =
    Db.getElement taco.posts id
