define 'contextFactory', ['store'], (DefaultStore)->
  (prop, Store = DefaultStore)->
    @is = (value)->
      Store[prop] = value

    this
