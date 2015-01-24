define 'callback', ['contextFactory'], (DefaultContextFactory)->
  (fn, ContextFactory = DefaultContextFactory)->

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

      fn.call(this)

    this
