module Context
    exposing
        ( Context
        , init
        , with
        , withIndex
        , child
        )

{-| A collection of helpers for dealing with elm-mdl render functions.
This is motivated by the following observations:

  - The triplet of `Mdl index model.mdl` occurs frequently in elm-mdl.
  - Dealing with indices is a bit tedious.

Instead of

    viewButton model index =
        Button.render Mdl
            (0 :: index)
            model.mdl
            [ Button.onClick Increment ]
            [ text "Add" ]

This becomes

    viewButton context model =
        (Button.render |> with context)
            [ Button.onClick Increment ]
            [ text "Add" ]

@docs Context, init, with, withIndex, child

-}

import Material


type alias MsgWrapper msg =
    Material.Msg msg -> msg


{-| Encapsulates the three arguments that are usually found together in elm-mdl.
In elm-mdl apps, these are typically:

  - toMsg: Mdl
  - index: [ 0 ] or (i :: index) in larger apps
  - container: model.mdl

-}
type alias Context container msg =
    { toMsg : MsgWrapper msg
    , index : List Int
    , container : container
    }


{-| Create a context record.
Construct this in your main view function, NOT in your model.
Typical usage:

    view model =
        let
            context = Context.init Mdl model.mdl
        in
            ...

-}
init :
    MsgWrapper msg
    -> container
    -> Context container msg
init makeMessage model =
    { toMsg = makeMessage
    , index = []
    , container = model
    }


{-| Apply the message and container arguments to a render function.
Use this for view functions that do not take an index, such as the root view function.

    view : Model -> Html Msg
    view model =
        let
            context =
                Context.init Mdl model.mdl
        in
            (Layout.render |> with context)
                [ Layout.fixedHeader
                ]
                { header = []
                , drawer = []
                , tabs = ( [], [] )
                , main = viewMain context model
                }

-}
with :
    Context container msg
    -> (MsgWrapper msg -> container -> viewFunction)
    -> viewFunction
with context render =
    render context.toMsg context.container


{-| Apply the message, index, and container arguments to a render function.
Use this for render functions which take an index argument, such as buttons.

Instead of

    Button.render Mdl (0 :: index) model.mdl
        [ Button.onClick Increment ]
        [ text "+" ]

it becomes

    (Button.render |> withIndex context 0)
        [ Button.onClick Increment ]
        [ text "+" ]

-}
withIndex :
    Context container msg
    -> Int
    -> (MsgWrapper msg -> List Int -> container -> viewFunction)
    -> viewFunction
withIndex context i render =
    render context.toMsg (i :: context.index) context.container


{-| Create a context for passing to a child component.
This just prepends `i` to the context's index list.
-}
child :
    Context container msg
    -> Int
    -> Context container msg
child ({ index } as context) i =
    { context | index = i :: index }
