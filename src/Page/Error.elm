module Page.Error
    exposing
        ( view
        )

import Html.Styled as Html exposing (Html)


view : List (Html msg)
view =
    [ Html.text "Error!" ]
