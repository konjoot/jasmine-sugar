define 'contextFactory', ['store', 'jasmine'], (DefaultStore, DefaultJasmineStore)->
  (prop, Store = DefaultStore, JasmineStore = DefaultJasmineStore)->
    Jasmine = new JasmineStore
    return {} unless Jasmine.defined()

    @is = (value)->
      Store[prop] = value

      Jasmine.instance().beforeEach.call this, ->
        eval "var #{prop} = #{Store[prop]};"

      Jasmine.instance().afterEach.call this, ->
        delete Store[prop]
        eval "delete #{prop};"

    this
