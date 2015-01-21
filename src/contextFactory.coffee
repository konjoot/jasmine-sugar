define 'contextFactory', ['store', 'jasmine'], (DefaultStore, DefaultJasmineStore)->
  (prop, Store = DefaultStore, Jasmine = DefaultJasmineStore)->
    @is = (value)->
      Store[prop] = value

      # Jasmine.beforeEach.call this, ->
      #   Store[prop] = value
      #   eval "var #{prop} = #{Store[prop]};"

      # Jasmine.afterEach.call this, ->
      #   delete Store[prop]
      #   eval "delete #{prop};"

    this
