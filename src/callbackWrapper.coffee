define 'callbackWrapper', ['contextFactory', 'store', 'privateStore'], (_ContextFactory_, _Store_, _Context_)->
  (fn, ContextFactory = _ContextFactory_, Store = _Store_, Context = _Context_)->

    factorySource = (prop)-> new ContextFactory(prop)

    Dump = (size = 4)->
      dump = []

      {
        push: (val)->
          dump.shift() if dump.push(val) > size

        buffer: (index)->
          return dump.join('') unless index?
          dump.join('')[index]
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
        inDSLParams = undefined if inDSLParams? and inDSLParams == false
        inString = undefined if inString? and inString == false

        switch
          when dump.buffer() == '.is(' and not inDSLParams?
            inDSLParams = beginMatched = true
          when char == '(' and inDSLParams? and not inString?
            parentheses.push char
          when char == ')' and inDSLParams? and not inString?
            inDSLParams = parentheses.pop()
            endMatched = true unless inDSLParams?
          when char.match(/'|"/)? and inDSLParams? and strings.indexOf(char) < 0 and not dump.buffer(2) == "\\"
            strings.push(char)
            inString = true
          when char.match(/'|"/)? and inDSLParams? and not dump.buffer(2) == "\\"
            strings.splice(strings.indexOf(char), 1)
            inString = strings.length > 0

      return '' unless fn?
      result = []
      beginWrap = 'function() { return '
      endWrap   = '; }'

      for char in fn.toString()
        analize char
        result.push(endWrap) if endMatched?
        result.push char
        result.push(beginWrap) if beginMatched?

      # console.log 'original'
      # console.log fn.toString()
      # console.log 'result'
      # console.log result.join('')

      eval "(#{result.join('')});"

    @run = do (properties = @properties(), fn = @prepareCallback())-> ->
      (->
        for __object in properties
          this[__object] = eval("(#{factorySource})('#{__object}')")
          eval("var #{__object} = this.#{__object};")

        fn1 =  eval("(#{fn})")
        console.log fn1.toString()
        fn1.call(this)
      ).call Context.get()

    this
