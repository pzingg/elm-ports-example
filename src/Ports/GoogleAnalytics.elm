port module Ports.GoogleAnalytics
    exposing
        ( FromElm(..)
        , googleAnalytics
        )

{-| From: <https://github.com/dillonkearns/elm-typescript-starter/tree/custom-types-spike>
-}

import Json.Encode


type FromElm
    = TrackEvent { category : String, action : String, label : Maybe String, value : Maybe Int }
    | TrackPage { path : String }


port googleAnalyticsFromElm : Json.Encode.Value -> Cmd msg



-- FROM ELM IMPLEMENTATION


googleAnalytics : FromElm -> Cmd msg
googleAnalytics from =
    from
        |> encodeFromElm
        |> googleAnalyticsFromElm


encodeFromElm : FromElm -> Json.Encode.Value
encodeFromElm from =
    case from of
        TrackEvent data ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "TrackEvent" )
                , ( "category", Json.Encode.string data.category )
                , ( "action", Json.Encode.string data.action )
                , ( "label", maybeEncode Json.Encode.string data.label )
                ]

        TrackPage data ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "TrackPage" )
                , ( "path", Json.Encode.string data.path )
                ]


{-| Encode a Maybe value. If the value is `Nothing` it will be encoded as `null`
import Json.Encode exposing (..)
maybeEncode int (Just 50)
--> int 50
maybeEncode int Nothing
--> null
-}
maybeEncode : (a -> Json.Encode.Value) -> Maybe a -> Json.Encode.Value
maybeEncode encoder =
    Maybe.map encoder >> Maybe.withDefault Json.Encode.null
