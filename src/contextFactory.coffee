define 'contextFactory', ['store', 'jasmine'], (DefaultStore, DefaultJasmine)->
  (prop, Store = DefaultStore, Jasmine = DefaultJasmine)->
    return {} unless Jasmine.defined()

    @is = (value)->
      Store[prop] = value

      do (Store = Store)->
        Jasmine.instance.beforeEach.call this, ->
          eval.call this, "var #{prop} = '#{Store[prop]}';"

        Jasmine.instance.afterEach.call this, ->
          delete Store[prop]
          eval.call this, "delete #{prop};"

    this
