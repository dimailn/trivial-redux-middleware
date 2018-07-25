import _ from 'lodash'
import axios from 'axios'
import {camelizeKeys, decamelizeKeys} from 'humps'

module.exports = ({dispatch}) -> (next) -> (action) ->
  return next(action) unless action.types and action.meta?.fetch

  action = _.cloneDeep(action)

  {fetch} = action.meta
  fetch.method ?= 'GET'
  console.error('The property action.meta.fetch must be an object') if typeof fetch isnt 'object'

  if action.camelizeKeys
    ['params', 'data'].forEach((prop) -> action.meta.fetch[prop] = decamelizeKeys(action.meta.fetch[prop]))

  next(type: action.types.load, meta: action.meta) unless action.isRequest


  axios(fetch)
    .then(
      (result) ->
        result = camelizeKeys(result) if action.camelizeKeys

        dispatch(
          type: action.types.success
          payload: result.data
          response: result
          meta: action.meta
        ) unless action.isRequest

        result

      (error) ->
        dispatch(
          type: action.types.failure
          payload: error.data
          response: error
          meta: action.meta
        ) unless action.isRequest

        Promise.reject error
    )

