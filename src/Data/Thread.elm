module Data.Thread
    exposing
        ( Thread
        )

import Data.Post exposing (Post)


type alias Thread =
    { op : Post
    , replies : List Post
    }
