# elm-ports-example

Demonstration of structured, type-safe Javascript interop for Elm, based on Murphy Randle's
["The Importance of Ports"](https://www.youtube.com/watch?v=P3pL85n9_5s) talk
at ElmConf US 2017. This little Elm app shows examples of three different
ports that use the same encoding/decoding convention.

Work is largely derived from these two projects:

-  https://github.com/dillonkearns/elm-typescript-starter/tree/custom-types-spike Design
  of a type-safe ports generator system, coming soon to ElmConf US 2018. This version
  provides a DecodingError type member on all "to Elm" subscriptions in case of
  invalid values on the Javascript side.
-  https://github.com/paulstatezny/elm-phoenix-websocket-ports Design of a "ports factory"
  in Javascript.

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).
