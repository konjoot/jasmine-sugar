define 'privateStore', ->
  PrivateStore = undefined

  {
    set: (value)->
      PrivateStore = value

    get: ->
      PrivateStore
  }
