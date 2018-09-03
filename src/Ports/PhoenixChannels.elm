port module Ports.PhoenixChannels
    exposing
        ( FromElm(..)
        , ToElm(..)
        , webSocket
        , webSocketSubscription
        )

{-| From: <https://github.com/paulstatezny/elm-phoenix-websocket-ports/>
See also: <http://graemehill.ca/websocket-clients-and-phoenix-channels/>
-}

import Json.Decode
import Json.Encode


type FromElm
    = Send { topic : String, event : String, payload : Json.Encode.Value }
    | Listen { topic : String, event : String }


type alias ReceivedPayload =
    { topic : String
    , event : String
    , payload : Json.Encode.Value
    }


type ToElm
    = Received ReceivedPayload
    | DecodingError String


port webSocketFromElm : Json.Encode.Value -> Cmd msg


port webSocketToElm : (Json.Decode.Value -> msg) -> Sub msg



-- FROM ELM IMPLEMENTATION


webSocket : FromElm -> Cmd msg
webSocket from =
    from
        |> encodeFromElm
        |> webSocketFromElm


encodeFromElm : FromElm -> Json.Encode.Value
encodeFromElm from =
    case from of
        Send { topic, event, payload } ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "Send" )
                , ( "topic", Json.Encode.string topic )
                , ( "event", Json.Encode.string topic )
                , ( "payload", payload )
                ]

        Listen { topic, event } ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "Send" )
                , ( "topic", Json.Encode.string topic )
                ]



-- TO ELM IMPLEMENTATION


webSocketSubscription : (ToElm -> msg) -> Sub msg
webSocketSubscription customTypeConstructor =
    (Json.Decode.decodeValue decodeToElm >> resultWithError >> customTypeConstructor)
        |> webSocketToElm


decodeToElm : Json.Decode.Decoder ToElm
decodeToElm =
    Json.Decode.field "kind" Json.Decode.string
        |> Json.Decode.maybe
        |> Json.Decode.andThen decodeKind


decodeKind : Maybe String -> Json.Decode.Decoder ToElm
decodeKind kind =
    case kind of
        Nothing ->
            DecodingError "missing kind"
                |> Json.Decode.succeed

        Just "Received" ->
            Json.Decode.map3 ReceivedPayload
                (Json.Decode.field "topic" Json.Decode.string)
                (Json.Decode.field "event" Json.Decode.string)
                (Json.Decode.field "payload" Json.Decode.value)
                |> Json.Decode.map Received

        Just other ->
            DecodingError ("invalid kind " ++ other)
                |> Json.Decode.succeed


resultWithError : Result String ToElm -> ToElm
resultWithError result =
    case result of
        Ok record ->
            record

        Err error ->
            DecodingError error
