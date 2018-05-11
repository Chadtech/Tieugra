module Data.Id
    exposing
        ( Id
        , fromString
        , toString
        )


type Id
    = Id String


fromString : String -> Id
fromString =
    Id


toString : Id -> String
toString (Id str) =
    str
