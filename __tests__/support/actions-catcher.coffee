export default class ActionsCatcher
  constructor: (@middleware) ->
    @dispatchedActions = []
    @emittedActions = []
    @storeMock = {
      dispatch: @dispatch
    }

  dispatch: (action) =>
    @dispatchedActions.push(action)

  next: (action) =>
    @emittedActions.push(action)

  getWrappedMiddleware: ->
    @middleware(@storeMock)(@next)
