-- Example Signals

Mouse.position
Window.dimensions
Keyboard.arrows

-- Operations

input = Signal.merge Keyboard.arrors Keyboard.wasd
search = Signal.sampleOn buttonClicksSignal inputBoxValueSignal

-- Shorthand

main : Signal Html
main = render <~ appState

-- Inputs

queryChannel : Channel String
queryChannel = channel ""

querySignal : Signal String
querySignal = subscribe queryChannel

render : AppState -> Html
render state =
  input
    [ on "keyPress" targetValue (send queryChannel)
    , value state.query
    ]
    []

-- Connecting it up

type AppState =
  { query : String }

appState : Signal AppState
appState = Signal.foldp stepState initialState querySignal

stepState : String -> AppState -> AppState
stepState query state = { state | query <- query }

initialState : AppState
initialState =
  { query = "" }
