define 'Analizer', ['Dumper'], (_Dumper_)->
  bufferSize = 9

  (Dumper = _Dumper_(bufferSize), parentheses = [], strings = [])->

    {
      inString: undefined
      endOfLine: undefined
      inCallback: undefined
      endMatched: undefined
      inDSLParams: undefined
      beginMatched: undefined
      callbackBegins: undefined

      push: (char)->
        Dumper.push char
        @clean()
        @analize()

      clean: ->
        @inString = undefined if @inString? and @inString == false
        @endOfLine = undefined if @endOfLine?
        @endMatched = undefined if @endMatched?
        @inDSLParams = undefined if @inDSLParams? and @inDSLParams == false
        @beginMatched = undefined if @beginMatched?
        @callbackBegins = undefined if @callbackBegins?

      buffer: -> Dumper.buffer()

      analize: (str = @buffer())->
        char     = str.slice(-1)
        previous = str.slice(-2)
        lastNine = str.slice(-9)
        lastFour = str.slice(-4)

        switch
          when lastNine == 'tion () {' and not @inCallback?
            @callbackBegins = @inCallback = true
          when char == '(' and @inDSLParams? and not @inString?
            parentheses.push char
          when char == ')' and @inDSLParams? and not @inString?
            @inDSLParams = parentheses.pop()
            @endMatched = true unless @inDSLParams?
          when char == "\n" and not @inString?
            @endOfLine = true
          when lastFour == '.is(' and not inDescribe?
            @inDSLParams = @beginMatched = true
          when char.match(/'|"/)? and @inDSLParams? and strings.indexOf(char) < 0 and not previous == "\\"
            strings.push(char)
            @inString = true
          when char.match(/'|"/)? and @inDSLParams? and not previous == "\\"
            strings.splice(strings.indexOf(char), 1)
            @inString = strings.length > 0
    }
