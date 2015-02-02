define 'callback', ['contextFactory', 'store', 'privateStore'], (_ContextFactory_, _Store_, _Context_)->
  (fn, ContextFactory = _ContextFactory_, Store = _Store_, Context = _Context_)->

    factorySource = (prop)-> new ContextFactory(prop)

    @properties = ->
      return [] unless fn?

      result     = []
      expression = /\n*(\w*)\.is\(.|\n*\)/g

      while true
        try
          match = (expression.exec fn.toString())[1]
          result.push match if match != undefined
        catch e then break

      result

    @run = do (properties = @properties())-> ->
      console.log this
      for __object in properties
        this[__object] = eval("(#{factorySource})('#{__object}')")
        eval("#{__object} = this.#{__object};")

      Context.set this
      console.log 'in Callback'
      fn.call(this)

    this
