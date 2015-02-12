define 'contextFactory', ['store', 'jasmine', 'privateStore'], (_Store_, _Jasmine_, _Context_)->
  (prop, Store = _Store_, Jasmine = _Jasmine_, Context = _Context_)->
    return {} unless Jasmine.defined()

    @is = (fn)->
      return unless fn?
      @defined = true
      origin   = this
      console.log this
      console.log prop
      console.log Context.get()
      # Store[prop] = fn

      Jasmine.instance.beforeEach ->
        console.log 'in beforeEach'
        # console.log collection
        # obj = fn()
        # this[prop] = fn.call this
        # eval("#{prop} = this.#{prop};")

      Jasmine.instance.afterEach ->
        # obj = origin
        # delete Store[prop]
        # eval "delete #{prop};"

    @value = -> Store[prop]

    @defined = false

    this
