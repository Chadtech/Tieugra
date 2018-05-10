module Return2
    exposing
        ( addMail
        , addMails
        , mail
        , mapMail
        , mapModel
        , model
        , withMail
        , withMails
        , withModel
        , withNoMail
        )

{-| This package makes it easier to build `(module, Mail msg)`, the typical result of an update function


# With

@docs withMail, withMails, withNoMail, withModel


# Add

@docs addMail, addMails


# Map

@docs mapModel, mapMail


# Get

@docs model, mail

-}

import Ports.Mail as Mail exposing (Mail)


{-| Pack a cmd with your model

    model
        |> withMail mail

-}
withMail : Mail msg -> model -> ( model, Mail msg )
withMail mail model =
    ( model, mail )


{-| Pack multiple cmds with your model

    model
        |> withMails [ mail0, mail1 ]

-}
withMails : List (Mail msg) -> model -> ( model, Mail msg )
withMails mails model =
    ( model, Mail.batch mails )


{-| Pack a model with your mail. This is useful if the business logic for your command is more complicated than the business logic for your model

    Close ->
        model.sessionId
            |> Ports.Close
            |> Ports.send
            |> withModel model

-}
withModel : model -> Mail msg -> ( model, Mail msg )
withModel =
    (,)


{-| Pack your model with no mail

    model
        |> withNoMail

-}
withNoMail : model -> ( model, Mail msg )
withNoMail model =
    ( model, Mail.none )


{-| Sometimes you need to add a cmd to an already packaged model and cmd.

    (model, mail0)
        |> addMail mail1

        -- == (model, Mail.batch [ mail1, mail0 ])

-}
addMail : Mail msg -> ( model, Mail msg ) -> ( model, Mail msg )
addMail newMail ( model, mail ) =
    ( model, Mail.batch [ newMail, mail ] )


{-| Add many mails to an already packaged model and mail.

    (model, mail0)
        |> addMails [ mail1, mail2 ]

        -- == (model, Cmd.batch [ mail0, mail1, mail2 ])

-}
addMails : List (Mail msg) -> ( model, Mail msg ) -> ( model, Mail msg )
addMails newMails ( model, mail ) =
    ( model, Mail.batch [ Mail.batch newMails, mail ] )


{-| Ideally you wouldnt have to deconstruct a tupled model and cmd, but if you need to, this function does it.

    Return2.model (model, mail) == model

-}
model : ( model, Mail msg ) -> model
model =
    Tuple.first


{-| Get the mail of an already tupled model and mail.

    Return2.cmd (model, mail) == mail

-}
mail : ( model, Mail msg ) -> Mail msg
mail =
    Tuple.second


{-| If you need to transform just the mail in a tuple, such as if you need to wrap a sub-modules msg type

    loginModel
        |> Login.update subMsg
        |> mapMail LoginMsg

-}
mapMail : (a -> b) -> ( model, Mail a ) -> ( model, Mail b )
mapMail f =
    Tuple.mapSecond (Mail.map f)


{-| If you need to transform just the model in a tuple, such as if you need to pack a submodel into the main model

    loginModel
        |> Login.update subMsg
        |> mapModel (setPage model Page.Login)

-}
mapModel : (a -> b) -> ( a, Mail msg ) -> ( b, Mail msg )
mapModel =
    Tuple.mapFirst
