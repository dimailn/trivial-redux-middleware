import trivialReduxMiddleware from '../src/index'
import trivialRedux from 'trivial-redux'
import MockAdapter from 'axios-mock-adapter'
import axios from 'axios'
import ActionsCatcher from './support/actions-catcher'

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


middleware = catcher = emittedActions = dispatchedActions = null

beforeEach ->
  catcher = new ActionsCatcher(trivialReduxMiddleware)
  middleware = catcher.getWrappedMiddleware()
  {emittedActions, dispatchedActions} = catcher

describe 'middleware', ->
  test 'green way', ->
    await middleware(api.actions.todos.index())

    expect(emittedActions.length).toBe 1
    expect(dispatchedActions.length).toBe 1

    expect(emittedActions[0].type).toBe api.types.todos.index.load
    expect(dispatchedActions[0].type).toBe api.types.todos.index.success
    expect(dispatchedActions[0].payload.length).toBe 2

  test 'road of fire', ->
    anotherApi = trivialRedux(nonExistent: '~non_existent')

    await middleware(anotherApi.actions.nonExistent.index())

    expect(emittedActions.length).toBe 1
    expect(dispatchedActions.length).toBe 1

    expect(emittedActions[0].type).toBe anotherApi.types.nonExistent.index.load
    expect(dispatchedActions[0].type).toBe anotherApi.types.nonExistent.index.failure


