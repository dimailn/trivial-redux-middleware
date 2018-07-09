import trivialReduxMiddleware from '../src/index'
import trivialRedux from 'trivial-redux'
import MockAdapter from 'axios-mock-adapter'
import axios from 'axios'

mock = new MockAdapter(axios)

mock.onGet('/todos.json').reply(
  200
  [
    { id: 1, title: 'TO DO SOMETHING 1'}
    { id: 2, title: 'TO DO SOMETHING 2'}
  ]
)


api = trivialRedux(
  todos: '/todos'
)

describe 'middleware', ->
  test 'green way', ->
    dispatchedActions = []
    dispatch = (action) ->
      dispatchedActions.push action

    emittedActions = []
    next = (action) ->
      emittedActions.push action

    middleware = trivialReduxMiddleware({dispatch})(next)

    await middleware(api.actions.todos.index())

    expect(emittedActions.length).toBe 1
    expect(dispatchedActions.length).toBe 1

    expect(emittedActions[0].type).toBe 'index/todos/PENDING'
    expect(dispatchedActions[0].type).toBe 'index/todos/SUCCESS'
    expect(dispatchedActions[0].payload.length).toBe 2

