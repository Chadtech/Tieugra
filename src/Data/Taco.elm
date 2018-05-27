module Data.Taco
    exposing
        ( Taco
        , empty
        , insertPost
        , insertThread
        )

import Data.Db as Db exposing (Db, Element)
import Data.Id exposing (Id)
import Data.Post exposing (Post)


type alias Taco =
    { threads : Db (List Id)
    , posts : Db Post
    }


empty : Taco
empty =
    { threads = Db.empty
    , posts = Db.empty
    }


insertThread : Taco -> Element (List Id) -> Taco
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
