define 'jasmine', ->
  Jasmine = undefined

  ->
    @set = (value)->
      Jasmine = value

    @instance = Jasmine

    @defined = ->
      Jasmine?

    this