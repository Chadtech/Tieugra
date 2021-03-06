module Html.Post
    exposing
        ( view
        )

import Colors
import Css exposing (..)
import Data.Post exposing (Post)
import Html.Custom exposing (p)
import Html.Styled as Html
    exposing
        ( Attribute
        , Html
        , br
        , div
        )
import Html.Styled.Attributes as Attrs exposing (css)
import Id exposing (Id)
import Style
import Time exposing (Posix)
import Util


view : ( Id, Maybe Post ) -> Html msg
view post =
    div
        [ css [ style ] ]
        (bodyView post)


style : Style
style =
    [ Style.border2
    , Style.defaultSpacing
    , backgroundColor Colors.background2
    , minHeight (px 100)
    ]
        |> Css.batch


bodyView : ( Id, Maybe Post ) -> List (Html msg)
bodyView ( id, maybePost ) =
    case maybePost of
        Just post ->
            [ metaDataView id post
            , post.content
                |> List.map sectionView
                |> List.intersperse (br [] [])
            ]
                |> List.concat

        Nothing ->
            [ "post"
            , Id.toString id
            , "not found"
            ]
                |> String.join " "
                |> Html.text
                |> List.singleton
                |> p []
                |> List.singleton


metaDataView : Id -> Post -> List (Html msg)
metaDataView id post =
    [ p
        []
        [ Html.text ("name : " ++ post.author) ]
    , p
        []
        [ Html.text ("post : " ++ Id.toString id) ]
    , p
        []
        [ Html.text (timeStr post.createdAt) ]
    , br [] []
    ]


timeStr : Posix -> String
timeStr time =
    "created at : " ++ Util.humanReadableTime time


sectionView : String -> Html msg
sectionView paragraph =
    p [] [ Html.text paragraph ]
