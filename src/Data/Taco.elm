module Data.Taco
    exposing
        ( Taco
        , empty
        , getThreads
        , getThreadsPosts
        , insertPost
        , insertThread
        )

import Data.Db as Db exposing (Db, Element)
import Data.Id exposing (Id)
import Data.Post exposing (Post)
import Data.Thread exposing (Thread)
import List.NonEmpty exposing (NonEmptyList)


type alias Taco =
    { threads : Db Thread
    , posts : Db Post
    }


empty : Taco
empty =
    { threads = Db.empty
    , posts = Db.empty
    }


insertThread : Taco -> Element Thread -> Taco
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


getThreads : Taco -> List (Element Thread)
getThreads taco =
    taco.threads
        |> Db.values


getThreadsPosts : Taco -> Thread -> NonEmptyList (Element (Maybe Post))
getThreadsPosts taco thread =
    List.NonEmpty.map (getPost taco) thread.posts


getPosts : Taco -> List Id -> List (Element (Maybe Post))
getPosts taco =
    List.map (getPost taco)


getPost : Taco -> Id -> Element (Maybe Post)
getPost taco id =
    Db.getElement taco.posts id
