module Page.Error
    exposing
        ( view
        )

import Html exposing (Html)


view : List (Html msg)
view =
    [ Html.text "Error!" ]
