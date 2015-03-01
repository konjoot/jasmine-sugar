define 'Context', ->
  Context = undefined

  {
    set: (value)->
      Context = value

    get: ->
      Context
  }
