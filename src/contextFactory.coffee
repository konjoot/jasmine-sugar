define 'contextFactory', ['store', 'jasmine'], (DefaultStore, DefaultJasmine)->
  (prop, Store = DefaultStore, Jasmine = DefaultJasmine)->
    return {} unless Jasmine.defined()

    @is = (value)->
      Store[prop] = value

      Jasmine.instance.beforeEach.call this, ->
        eval "var #{prop} = #{Store[prop]};"

      Jasmine.instance.afterEach.call this, ->
        delete Store[prop]
        eval "delete #{prop};"

    this
