define 'callbackWrapper', ['contextFactory', 'store', 'privateStore'], (_ContextFactory_, _Store_, _Context_)->
  (fn, ContextFactory = _ContextFactory_, Store = _Store_, Context = _Context_)->

    factorySource = (prop)-> new ContextFactory(prop)

    @properties = ->
      return [] unless fn?

      result     = []
      expression = /\n*(\w*)\.is\(.|\n*\)/g

      while true
        try
          match = (expression.exec fn.toString())[1]
          result.push match if match?
        catch e then break

      result

    @prepareCallback = ->
      endMatched   =
      beginMatched = undefined

      analize = (char)->
        # some code here )

      return '' unless fn?
      result = []
      beginWrap = 'function(){return '
      endWrap   = ';}'

      for char in fn.toString()
        analize char
        result.push(endWrap) if endMatched?
        result.push char
        result.push(beginWrap) if beginMatched?

      result.join ''

      fn.toString()

    @run = do (properties = @properties(), fn = @prepareCallback())-> ->
      (->
        for __object in properties
          this[__object] = eval("(#{factorySource})('#{__object}')")
          eval("#{__object} = this.#{__object};")

        # Context.set this
        fn.call(this)
      ).call Context.get()

    this
