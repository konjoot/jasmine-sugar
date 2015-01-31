define 'callback', ['contextFactory', 'store', 'privateStore'], (_ContextFactory_, _Store_, _Context_)->
  (fn, ContextFactory = _ContextFactory_, Store = _Store_, Context = _Context_)->

    factorySource = (prop)-> new ContextFactory(prop)

    @properties = ->
      return [] unless fn?

      result     = []
      expression = /(\w*)\.is\(.*\)/g

      while true
        try result.push (expression.exec fn.toString())[1]
        catch e then break

      result

    @run = do (properties = @properties())-> ->
      for obj in properties
        this[obj] = eval("(#{factorySource})('#{obj}')")
        eval("#{obj} = this.#{obj};")

      Context.set this

      fn.call(this)

    this
