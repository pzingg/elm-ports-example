module Main exposing (..)

import Html exposing (Html, text, div, h1, br, img, label, input, button)
import Html.Attributes exposing (src, type_, value)
import Html.Events exposing (onClick, onInput)
import Json.Decode
import Json.Encode
import Ports.GoogleAnalytics
import Ports.LocalStorage
import Ports.PhoenixChannels


---- MODEL ----


type alias Model =
    { value : String
    }


init : ( Model, Cmd Msg )
init =
    ( { value = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = ValueInput String
    | StoreValue
    | LoadValue
    | SendPageView
    | SendWebSocket
    | LocalStorageReceived Ports.LocalStorage.ToElm
    | WebSocketReceived Ports.PhoenixChannels.ToElm


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ValueInput value ->
            ( { model | value = value }, Cmd.none )

        StoreValue ->
            let
                data =
                    Ports.LocalStorage.StoreItem
                        { key = "value"
                        , item = Json.Encode.string model.value
                        }
            in
                ( { model | value = "" }, Ports.LocalStorage.localStorage data )

        LoadValue ->
            let
                data =
                    Ports.LocalStorage.LoadItem
                        { key = "value"
                        }
            in
                ( { model | value = "" }, Ports.LocalStorage.localStorage data )

        SendPageView ->
            let
                data =
                    Ports.GoogleAnalytics.TrackPage
                        { path = "/elm"
                        }
            in
                ( model, Ports.GoogleAnalytics.googleAnalytics data )

        SendWebSocket ->
            let
                data =
                    Ports.PhoenixChannels.Send
                        { topic = "chat"
                        , event = "elm"
                        , payload = Json.Encode.string model.value
                        }
            in
                ( model, Ports.PhoenixChannels.webSocket data )

        LocalStorageReceived data ->
            case data of
                Ports.LocalStorage.LoadedItem { key, item } ->
                    let
                        value =
                            Json.Decode.decodeValue Json.Decode.string item
                                |> Result.withDefault "payload decoding error"
                    in
                        ( { model | value = value }, Cmd.none )

                Ports.LocalStorage.DecodingError error ->
                    ( { model | value = error }, Cmd.none )

        WebSocketReceived data ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ img [ src "/logo.svg" ] []
        , h1 [] [ text "Your Elm App is working!" ]
        , label [] [ text "Edit Value" ]
        , br [] []
        , input [ type_ "text", value model.value, onInput ValueInput ] []
        , br [] []
        , button [ onClick StoreValue ] [ text "Store Value" ]
        , br [] []
        , button [ onClick LoadValue ] [ text "Load Value" ]
        , br [] []
        , button [ onClick SendPageView ] [ text "Send Page View" ]
        , br [] []
        , button [ onClick SendWebSocket ] [ text "Send WebSocket" ]
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions =
            (\_ ->
                Sub.batch
                    [ Ports.LocalStorage.localStorageSubscription LocalStorageReceived
                    , Ports.PhoenixChannels.webSocketSubscription WebSocketReceived
                    ]
            )
        }
