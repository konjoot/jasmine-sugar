define 'callbackWrapper', ['contextFactory', 'store', 'privateStore'], (_ContextFactory_, _Store_, _Context_)->
  (fn, ContextFactory = _ContextFactory_, Store = _Store_, Context = _Context_)->

    factorySource = (prop)-> new ContextFactory(prop)

    Dump = (size = 4)->
      dump = []

      {
        push: (val)->
          dump.shift() if dump.push(val) > size

        buffer: ->
          dump.join('')
      }

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
      inString      =
      endMatched    =
      inDSLParams   =
      beginMatched  =
      inParenthesis = undefined
      parentheses  = []
      strings     = []
      dstrings     = []

      dump = Dump()


      analize = (char)->
        dump.push char
        beginMatched = undefined if beginMatched?
        endMatched = undefined if endMatched?

        switch
          when dump.buffer() == '.is('
            inDSLParams = beginMatched = true
          when char == '(' and inDSLParams? and !inString?
            parentheses.push char
          when char == ')' and inDSLParams? and !inString?
            inDSLParams = parentheses.pop()
            endMatched = !inDSLParams?
          when char.match /'|"/ and inDSLParams? and strings.indexOf(char) < 0
            strings.push(char)
            inString = true
          when char.match /'|"/ and inDSLParams?
            inString = strings.splice(strings.indexOf(char), 1).length > 0

      return '' unless fn?
      result = []
      beginWrap = 'function() { return '
      endWrap   = '; }'

      for char in fn.toString()
        analize char
        result.push(endWrap) if endMatched?
        result.push char
        result.push(beginWrap) if beginMatched?

      eval "(#{result.join('')});"

    @run = do (properties = @properties(), fn = @prepareCallback())-> ->
      (->
        for __object in properties
          this[__object] = eval("(#{factorySource})('#{__object}')")
          eval("#{__object} = this.#{__object};")

        # Context.set this
        fn.call(this)
      ).call Context.get()

    this
