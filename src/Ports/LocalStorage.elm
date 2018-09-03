port module Ports.LocalStorage
    exposing
        ( FromElm(..)
        , ToElm(..)
        , LoadedItemPayload
        , localStorage
        , localStorageSubscription
        )

{-| From: <https://github.com/dillonkearns/elm-typescript-starter/blob/custom-types-spike>
-}

import Json.Decode
import Json.Encode


type FromElm
    = StoreItem { key : String, item : Json.Encode.Value }
    | LoadItem { key : String }
    | ClearItem { key : String }


type alias LoadedItemPayload =
    { key : String, item : Json.Encode.Value }


type ToElm
    = LoadedItem LoadedItemPayload
    | DecodingError String


port localStorageFromElm : Json.Encode.Value -> Cmd msg


port localStorageToElm : (Json.Decode.Value -> msg) -> Sub msg



-- FROM ELM IMPLEMENTATION


localStorage : FromElm -> Cmd msg
localStorage from =
    from
        |> encodeFromElm
        |> localStorageFromElm


encodeFromElm : FromElm -> Json.Encode.Value
encodeFromElm from =
    case from of
        StoreItem { key, item } ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "StoreItem" )
                , ( "key", Json.Encode.string key )
                , ( "item", item )
                ]

        LoadItem { key } ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "LoadItem" )
                , ( "key", Json.Encode.string key )
                ]

        ClearItem { key } ->
            Json.Encode.object
                [ ( "kind", Json.Encode.string "ClearItem" )
                , ( "key", Json.Encode.string key )
                ]



-- TO ELM IMPLEMENTATION


localStorageSubscription : (ToElm -> msg) -> Sub msg
localStorageSubscription customTypeConstructor =
    (Json.Decode.decodeValue decodeToElm >> resultWithError >> customTypeConstructor)
        |> localStorageToElm


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

        Just "LoadedItem" ->
            Json.Decode.map2 LoadedItemPayload
                (Json.Decode.field "key" Json.Decode.string)
                (Json.Decode.field "item" Json.Decode.value)
                |> Json.Decode.map LoadedItem

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
