import _ from 'lodash'
import axios from 'axios'

module.exports = ({dispatch}) -> (next) -> (action) ->
  return next(action) unless action.types and action.meta?.fetch

  {fetch} = action.meta

  console.error('The property action.meta.fetch must be an object') if typeof fetch isnt 'object'
  console.error('HTTP method for network queries is required') unless fetch.method?

  try
    result = await axios(fetch)
    dispatch(
      type: action.types.success
      payload: result.data
      response: result
      meta: action.meta
    )
    result
  catch error
    dispatch(
      type: action.types.failure
      payload: error.data
      response: error
      meta: action.meta
    )
    error

  next(type: action.types.load, meta: action.meta)
