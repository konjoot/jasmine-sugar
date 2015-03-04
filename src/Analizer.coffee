define 'Analizer', ->
  ->
    inString       =
    inCallback     =
    inDSLParams    =
    inParenthesis  =
    callbackBegins = undefined
    parentheses  = []
    strings      = []

    Dump = (size = 9)->
      dump = []

      {
        push: (val)->
          dump.shift() if dump.push(val) > size

        buffer: (index)->
          return dump.join('') unless index?
          dump.join('')[index]
      }

    dump = Dump()

    {
      push: (char)->
        dump.push char
        inString = undefined if inString? and inString == false
        @endOfLine = undefined if @endOfLine?
        @endMatched = undefined if @endMatched?
        inDSLParams = undefined if inDSLParams? and inDSLParams == false
        @beginMatched = undefined if @beginMatched?
        callbackBegins = undefined if callbackBegins?

        switch
          when dump.buffer() == 'tion () {' and not inCallback?
            callbackBegins = inCallback = true
          when char == '(' and inDSLParams? and not inString?
            parentheses.push char
          when char == ')' and inDSLParams? and not inString?
            inDSLParams = parentheses.pop()
            @endMatched = true unless inDSLParams?
          when dump.buffer().substring(8) == "\n" and not inString?
            @endOfLine = true
          when dump.buffer().substring(5) == '.is(' and not inDescribe?
            inDSLParams = @beginMatched = true
          when char.match(/'|"/)? and inDSLParams? and strings.indexOf(char) < 0 and not dump.buffer(7) == "\\"
            strings.push(char)
            inString = true
          when char.match(/'|"/)? and inDSLParams? and not dump.buffer(7) == "\\"
            strings.splice(strings.indexOf(char), 1)
            inString = strings.length > 0

      endOfLine: undefined
      endMatched: undefined
      beginMatched: undefined
    }