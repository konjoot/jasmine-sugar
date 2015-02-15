define 'PrivateStore', ->
  PrivateStore = undefined

  {
    set: (value)->
      PrivateStore = value

    get: ->
      PrivateStore
  }
