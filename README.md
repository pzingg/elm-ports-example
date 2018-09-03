# elm-ports-example

Demonstration of structured, type-safe Javascript interop for Elm, based on Murphy Randle's
observations at ElmConf Paris 2018. The Elm app showw examples of three different
ports that use the same encoding/decoding convention.

Work is largely derived from these two projects:

-  https://github.com/dillonkearns/elm-typescript-starter/tree/custom-types-spike Design
  of a type-safe ports generator system, coming soon to ElmConf US 2018. This version
  provides a DecodingError type member on all "to Elm" subscriptions in case of
  invalid values on the Javascript side.
-  https://github.com/paulstatezny/elm-phoenix-websocket-ports Design of a "ports factory"
  in Javascript.

This project is bootstrapped with [Create Elm App](https://github.com/halfzebra/create-elm-app).
