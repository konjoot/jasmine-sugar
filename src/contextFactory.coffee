define 'contextFactory', ['store', 'jasmine', 'privateStore'], (_Store_, _Jasmine_, _Context_)->
  (prop, Store = _Store_, Jasmine = _Jasmine_, Context = _Context_)->
    return {} unless Jasmine.defined()

    @is = (value)->
      return unless value?
      @defined    = true
      Store[prop] = value

      Jasmine.instance.beforeEach.call Context.get(), ->
        this[prop] = Store[prop]
        eval("#{prop} = this.#{prop};")

      Jasmine.instance.afterEach.call Context.get(), ->
        delete Store[prop]
        eval "delete #{prop};"

    @value = -> Store[prop]

    @defined = false

    this
