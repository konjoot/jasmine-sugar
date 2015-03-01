define 'Jasmine', ->
  Jasmine = undefined unless Jasmine?

  {
    instance: do (Jasmine = Jasmine)-> Jasmine

    set: (value)-> @instance = Jasmine = value
  }
