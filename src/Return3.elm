module Return3
    exposing
        ( Return
        , addMail
        , addMails
        , incorp
        , mail
        , mapMail
        , mapModel
        , mapReply
        , model
        , reply
        , withNoReply
        , withNothing
        , withReply
        , withTuple
        )

{-| This package makes it easier to build `(module, Mail msg, reply)` a common return value for big sub-modules. See the readme for an explanation of what `Return3` is all about.


# Return

@docs Return


# With

@docs withReply, withNoReply, withTuple, withNothing


# Add

@docs addMail, addMails


# Map

@docs mapModel, mapMail, mapReply


# Get

@docs model, mail, reply


# Incorporate

@docs incorp

-}

import Ports.Mail as Mail exposing (Mail)
import Return2 as R2


{-| This alias formalizes that this particular triple is our return value.
-}
type alias Return model msg reply =
    ( model, Mail msg, Maybe reply )


{-| Add a reply to your tuple.

    model
        |> R2.withNoMail
        |> R3.withReply UserNameChanged

-}
withReply : reply -> ( model, Mail msg ) -> Return model msg reply
withReply reply ( model, mail ) =
    ( model, mail, Just reply )


{-| Dont add a reply to your tuple.

    FetchingData
        |> R2.withMail getLocalStorage
        |> R3.withNoReply

-}
withNoReply : ( model, Mail msg ) -> Return model msg reply
withNoReply ( model, mail ) =
    ( model, mail, Nothing )


{-| If building your reply takes a lot of work, use this function.

    calculate width height x y
        |> center model.size
        |> UpdateSpace
        |> R3.withTuple
            (model |> R2.withNoMail)

-}
withTuple : ( model, Mail msg ) -> reply -> Return model msg reply
withTuple ( model, mail ) reply =
    ( model, mail, Just reply )


{-| Return the model with no mail and no reply

    model
        |> withNothing

-}
withNothing : model -> Return model msg reply
withNothing model =
    ( model, Mail.none, Nothing )


{-| Ideally you wouldnt have to deconstruct a `Return`, but if you need to, this function does it.

    Return3.model (model, mail, Nothing) == model

-}
model : Return model msg reply -> model
model ( model, _, _ ) =
    model


{-| Get the mail of an already packed `Return`.

    Return3.mail (model, mail, reply) == mail

-}
mail : Return model msg reply -> Mail msg
mail ( _, mail, _ ) =
    mail


{-| Get the reply of an already packed `Return`, if it exists

    Return3.reply (model, mail, maybeReply) == maybeReply

-}
reply : Return model msg reply -> Maybe reply
reply ( _, _, reply ) =
    reply


{-| Sometimes you need to add a mail to an already packaged `Return`

    (model, mail0, reply)
        |> addMail mail1

        -- == (model, Mail.batch [ mail1, mail0 ], reply)

-}
addMail : Mail msg -> Return model msg reply -> Return model msg reply
addMail newMail ( model, mail, reply ) =
    ( model, Mail.batch [ newMail, mail ], reply )


{-| Add many mails to an already packaged `Return`

    (model, mail0, reply)
        |> addMails [ mail1, mail2 ]

        -- == (model, Mail.batch [ mail0, mail1, mail2 ], reply)

-}
addMails : List (Mail msg) -> Return model msg reply -> Return model msg reply
addMails newMails ( model, mail, reply ) =
    ( model, Mail.batch [ Mail.batch newMails, mail ], reply )


{-| If you need to transform just the model in a `Return`, such as if you need to pack a submodel into the main model

    loginModel
        |> Login.update subMsg
        |> mapModel (setPage model Page.Login)

-}
mapModel : (a -> b) -> Return a msg reply -> Return b msg reply
mapModel f ( model, mail, reply ) =
    ( f model, mail, reply )


{-| If you need to transform just the mail in a `Return`, such as if you need to wrap a sub-modules msg type

    loginModel
        |> Login.update subMsg
        |> mapMail LoginMsg

-}
mapMail : (a -> b) -> Return model a reply -> Return model b reply
mapMail f ( model, mail, reply ) =
    ( model, Mail.map f mail, reply )


{-| -}
mapReply : (Maybe a -> Maybe b) -> Return model msg a -> Return model msg b
mapReply f ( model, mail, reply ) =
    ( model, mail, f reply )


{-| `Return`s contain a reply, and that reply needs to be handled much like a `msg` does in an update function.

    loginModel
        |> Login.update loginMsg
        |> R3.mapMail LoginMsg
        |> incorp handleLoginReply model


    handleLoginReply : Login.Model -> Maybe Reply -> Model -> (Model, Mail Msg)
    handleLoginreply loginModel maybeReply model =
        case maybeReply of
            Nothing ->
                { model | page = Login loginModel }
                    |> R2.withNoMail

            Just (LoggedIn user) ->
                { model
                    | page = Home Home.init
                    , user = Just user
                }
                    |> R2.withNoMail

-}
incorp : (subModel -> Maybe reply -> model -> ( model, Mail msg )) -> model -> Return subModel msg reply -> ( model, Mail msg )
incorp f model ( subModel, mail, reply ) =
    f subModel reply model
        |> R2.addMail mail
