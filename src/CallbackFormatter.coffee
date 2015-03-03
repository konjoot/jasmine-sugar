define 'CallbackFormatter', ['ContextFactory'], (_ContextFactory_)->
  (ContextFactory = _ContextFactory_)->
    result_string = []
    line = []
    offset = ''

    inString       =
    endOfLine      =
    endMatched     =
    inCallback     =
    inDSLParams    =
    beginMatched   =
    inParenthesis  =
    callbackBegins = undefined

    parentheses  = []
    strings      = []

    beginWrap = 'function() { return '
    endWrap   = '; }'


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

    analize = (char)->
      dump.push char
      inString = undefined if inString? and inString == false
      endOfLine = undefined if endOfLine?
      endMatched = undefined if endMatched?
      inDSLParams = undefined if inDSLParams? and inDSLParams == false
      beginMatched = undefined if beginMatched?
      callbackBegins = undefined if callbackBegins?

      switch
        when dump.buffer() == 'tion () {' and not inCallback?
          callbackBegins = inCallback = true
        when char == '(' and inDSLParams? and not inString?
          parentheses.push char
        when char == ')' and inDSLParams? and not inString?
          inDSLParams = parentheses.pop()
          endMatched = true unless inDSLParams?
        when dump.buffer().substring(8) == "\n" and not inString?
          endOfLine = true
        when dump.buffer().substring(5) == '.is(' and not inDescribe?
          inDSLParams = beginMatched = true
        when char.match(/'|"/)? and inDSLParams? and strings.indexOf(char) < 0 and not dump.buffer(7) == "\\"
          strings.push(char)
          inString = true
        when char.match(/'|"/)? and inDSLParams? and not dump.buffer(7) == "\\"
          strings.splice(strings.indexOf(char), 1)
          inString = strings.length > 0


    clearLine = -> line = []

    factoryReplacer = (match, p1)->
      return unless p1?
      return match if p1.length < 1
      match.replace(p1, p1 + offset)

    mainReplacer = (match, p1, p2)->
      return unless p1? && p2?
      offset = p1
      "#{p1}var #{p2} = void 0;\n" +
      "#{p1}var _#{p2}_ = new (#{ContextFactory.toString().replace(/(\s*){1}.*/g, factoryReplacer)})('#{p2}', evaluator, Jasmine, Store);\n" +
      match.replace(p2, "_#{p2}_")

    describeReplacer = (match, p1)->
      match.replace(p1, "_#{p1}_") if p1?

    pushToResult = ->
      joined_line = line.join('')
      joined_line = joined_line.replace(/(\s*)(\w*)\.is\(.*/g, mainReplacer)
      joined_line = joined_line.replace(/.*(describe)\(.*/g, describeReplacer)
      joined_line = joined_line.replace(/.*([xfd]{1}describe)\(.*/g, describeReplacer)
      result_string.push(joined_line) and clearLine()

    {
      push: (char)->
        analize char
        line.push endWrap if endMatched?
        line.push char
        line.push beginWrap if beginMatched?
        pushToResult() if endOfLine?

      result: ->
        pushToResult()
        result_string.join('')
    }
