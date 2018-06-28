import _ from 'lodash'
import axios from 'axios'
import {camelizeKeys} from 'humpsnpm '

module.exports = ({dispatch}) -> (next) -> (action) ->
  return next(action) unless action.types and action.meta?.fetch

  {types} = action
  action = _.pickBy(action, (value, key) -> key is 'types')
  action = _.cloneDeep action
  action.types = types

  {fetch} = action.meta
  fetch.method ?= 'GET'
  console.error('The property action.meta.fetch must be an object') if typeof fetch isnt 'object'

  try
    result = await axios(fetch)

    result = camelizeKeys(result) if action.camelizeKeys

    dispatch(
      type: action.types.success
      payload: result.data
      response: result
      meta: action.meta
    )
    return result
  catch error
    dispatch(
      type: action.types.failure
      payload: error.data
      response: error
      meta: action.meta
    )
    return error

  next(type: action.types.load, meta: action.meta)
