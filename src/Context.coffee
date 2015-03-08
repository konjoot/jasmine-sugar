define 'Context', ->
  Context = undefined

  -> (value)->
    return Context unless value?
    Context = value
