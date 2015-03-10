define 'Analizer', ['Dumper'], (_Dumper_)->
  (Dumper = _Dumper_())->
    inString       = undefined unless inString?
    inCallback     = undefined unless inCallback?
    inDSLParams    = undefined unless inDSLParams?
    inParenthesis  = undefined unless inParenthesis?
    callbackBegins = undefined unless callbackBegins?
    parentheses  = [] unless parentheses?
    strings      = [] unless strings?

    {
      push: (char)->
        Dumper.push char
        inString = undefined if inString? and inString == false
        @endOfLine = undefined if @endOfLine?
        @endMatched = undefined if @endMatched?
        inDSLParams = undefined if inDSLParams? and inDSLParams == false
        @beginMatched = undefined if @beginMatched?
        callbackBegins = undefined if callbackBegins?

        switch
          when Dumper.buffer() == 'tion () {' and not inCallback?
            callbackBegins = inCallback = true
          when char == '(' and inDSLParams? and not inString?
            parentheses.push char
          when char == ')' and inDSLParams? and not inString?
            inDSLParams = parentheses.pop()
            @endMatched = true unless inDSLParams?
          when Dumper.buffer().substring(8) == "\n" and not inString?
            @endOfLine = true
          when Dumper.buffer().substring(5) == '.is(' and not inDescribe?
            inDSLParams = @beginMatched = true
          when char.match(/'|"/)? and inDSLParams? and strings.indexOf(char) < 0 and not Dumper.buffer(7) == "\\"
            strings.push(char)
            inString = true
          when char.match(/'|"/)? and inDSLParams? and not Dumper.buffer(7) == "\\"
            strings.splice(strings.indexOf(char), 1)
            inString = strings.length > 0

      endOfLine: undefined

      endMatched: undefined

      beginMatched: undefined
    }