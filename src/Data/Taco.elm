module Data.Taco
    exposing
        ( Taco
        , clearDbs
        , getPosts
        , getThread
        , getThreadsOfBoard
        , getThreadsPosts
        , init
        , insertPost
        , insertThread
        , setDefaultName
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
import Set exposing (Set)


type alias Taco =
    { boards : Db (List Id)
    , threads : Db Thread
    , posts : Db Post
    , navigationKey : Navigation.Key
    , seed : Seed
    , defaultName : Maybe String
    }


init : Navigation.Key -> Flags -> Taco
init key flags =
    { boards = Db.empty
    , threads = Db.empty
    , posts = Db.empty
    , navigationKey = key
    , seed = flags.seed
    , defaultName = flags.defaultName
    }



-- HELPERS --


setDefaultName : String -> Taco -> Taco
setDefaultName defaultName taco =
    { taco | defaultName = Just defaultName }


setSeed : Seed -> Taco -> Taco
setSeed seed taco =
    { taco | seed = seed }


insertThread : Id -> Id -> Thread -> Taco -> Taco
insertThread boardId threadId thread taco =
    { taco
        | threads =
            Db.insert threadId thread taco.threads
        , boards =
            Db.update boardId (Just << addToBoard threadId) taco.boards
    }


addToBoard : Id -> Maybe (List Id) -> List Id
addToBoard threadId maybeBoard =
    case maybeBoard of
        Just board ->
            if List.member threadId board then
                board
            else
                threadId :: board

        Nothing ->
            threadId :: []


insertPost : Id -> Post -> Taco -> Taco
insertPost id post taco =
    { taco
        | posts =
            Db.insert id post taco.posts
    }


getThread : Taco -> Id -> ( Id, Maybe Thread )
getThread taco id =
    Db.get taco.threads id


getThreadsOfBoard : Taco -> Id -> List ( Id, Thread )
getThreadsOfBoard taco boardId =
    boardId
        |> Db.get taco.boards
        |> Tuple.second
        |> Maybe.withDefault []
        |> getThreads taco


getThreads : Taco -> List Id -> List ( Id, Thread )
getThreads taco threadIds =
    case threadIds of
        first :: rest ->
            case Tuple.second <| Db.get taco.threads first of
                Just thread ->
                    ( first, thread ) :: getThreads taco rest

                Nothing ->
                    getThreads taco rest

        [] ->
            []


getThreadsPosts : Taco -> Thread -> NonEmptyList ( Id, Maybe Post )
getThreadsPosts taco thread =
    List.NonEmpty.map (getPost taco) thread.posts


getPosts : Taco -> List Id -> List ( Id, Maybe Post )
getPosts taco =
    List.map (getPost taco)


getPost : Taco -> Id -> ( Id, Maybe Post )
getPost taco id =
    Db.get taco.posts id


clearDbs : Taco -> Taco
clearDbs taco =
    { taco
        | posts = Db.empty
        , threads = Db.empty
    }
