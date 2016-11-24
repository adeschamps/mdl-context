module Context
    exposing
        ( Context
        , init
        , root
        , with
        , child
        )

import Parts


type alias Msg context msg =
    Parts.Msg context msg -> msg


{-| Encapsulates the three arguments that are usually found together in elm-mdl.
-}
type alias Context container msg =
    { container : container
    , index : Parts.Index (List Int)
    , mapMessage : Msg container msg
    }


{-| Create a context record
-}
init :
    Msg container msg
    -> container
    -> Context container msg
init mapMessage model =
    { container = model
    , index = []
    , mapMessage = mapMessage
    }


{-| Apply the message and container arguments to a render function.
Use this for the main view function, which does not take an index argument.
For most other cases, use `with`.

    view : Model -> Html Msg
    view model =
        let
            context =
                Context.init Mdl model.mdl
        in
            (Context.root context Layout.render)
                [ Layout.fixedHeader
                ]
                { header = []
                , drawer = []
                , tabs = ( [], [] )
                , main = viewMain context model
                }
-}
root :
    Context container msg
    -> (Msg container msg -> container -> viewFunction)
    -> viewFunction
root context render =
    render context.mapMessage context.container


{-| Apply the message, index, and container arguments to a render function.
Instead of

    Button.render Mdl (0 :: index) model.mdl
        [ Button.onClick Increment ]
        [ text "+" ]

it becomes

    (with context 0 Button.render)
        [ Button.onClick Increment ]
        [ text "+" ]
-}
with :
    Context container msg
    -> Int
    -> (Msg container msg -> Parts.Index (List Int) -> container -> viewFunction)
    -> viewFunction
with context i render =
    render context.mapMessage (i :: context.index) context.container


{-| Create a context for passing to a child component.
This just prepends `i` to the context's index list.
-}
child :
    Context container msg
    -> Int
    -> Context container msg
child ({ index } as context) i =
    { context | index = i :: index }
