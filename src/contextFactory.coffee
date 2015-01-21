define 'contextFactory', ['store', 'utils'], (DefaultStore, u)->
  (prop, Store = DefaultStore)->
    @is = (value)->
      Store[prop] = u(value).isAFunction() && value() || value

    this
