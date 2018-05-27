module Return
    exposing
        ( addCmd
        , mapCmd
        , mapModel
        , withCmd
        , withCmds
        , withNoCmd
        )


withCmd : Cmd msg -> model -> ( model, Cmd msg )
withCmd cmd model =
    ( model, cmd )


withCmds : List (Cmd msg) -> model -> ( model, Cmd msg )
withCmds cmds model =
    ( model, Cmd.batch cmds )


withNoCmd : model -> ( model, Cmd msg )
withNoCmd model =
    ( model, Cmd.none )


addCmd : Cmd msg -> ( model, Cmd msg ) -> ( model, Cmd msg )
addCmd cmd0 ( model, cmd1 ) =
    ( model, Cmd.batch [ cmd0, cmd1 ] )


mapCmd : (a -> b) -> ( model, Cmd a ) -> ( model, Cmd b )
mapCmd f =
    Tuple.mapSecond (Cmd.map f)


mapModel : (a -> b) -> ( a, Cmd msg ) -> ( b, Cmd msg )
mapModel =
    Tuple.mapFirst
