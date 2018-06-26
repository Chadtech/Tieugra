module Data.Taco
    exposing
        ( Taco
        , getThreads
        , getThreadsPosts
        , init
        , insertPost
        , insertThread
        , setSeed
        )

import Browser.Navigation as Navigation
import Data.Flags exposing (Flags)
import Data.Post exposing (Post)
import Data.Thread exposing (Thread)
import Db exposing (Db)
import Id exposing (Id)
import List.NonEmpty exposing (NonEmptyList)
import Random exposing (Seed)


type alias Taco =
    { threads : Db Thread
    , posts : Db Post
    , navigationKey : Navigation.Key
    , apiKeySet : Bool
    , seed : Seed
    }


init : Navigation.Key -> Flags -> Taco
init key flags =
    { threads = Db.empty
    , posts = Db.empty
    , navigationKey = key
    , apiKeySet = flags.apiKeySet
    , seed = flags.seed
    }


setSeed : Taco -> Seed -> Taco
setSeed taco seed =
    { taco | seed = seed }


insertThread : Id -> Thread -> Taco -> Taco
insertThread id thread taco =
    { taco
        | threads =
            Db.insert id thread taco.threads
    }


insertPost : Id -> Post -> Taco -> Taco
insertPost id post taco =
    { taco
        | posts =
            Db.insert id post taco.posts
    }


getThreads : Taco -> List ( Id, Thread )
getThreads taco =
    Db.toList taco.threads


getThreadsPosts : Taco -> Thread -> NonEmptyList ( Id, Maybe Post )
getThreadsPosts taco thread =
    List.NonEmpty.map (getPost taco) thread.posts


getPosts : Taco -> List Id -> List ( Id, Maybe Post )
getPosts taco =
    List.map (getPost taco)


getPost : Taco -> Id -> ( Id, Maybe Post )
getPost taco id =
    Db.get taco.posts id
