define 'CallbackFormatter', ['Store', 'Evaluator', 'Jasmine', 'DslFactory', 'Analizer'], (_Store_, _Evaluator_, _Jasmine_, _DslFactory_, _Analizer_)->

  (Store = _Store_(), Evaluator = _Evaluator_(), Jasmine = _Jasmine_, DslFactory = _DslFactory_, Analizer = _Analizer_())->
    line          = []
    offset        = ''
    status        = {}
    result_string = []

    clearLine = -> line = []

    mainReplacer = (match, p1, p2)->
      return unless p1? && p2?
      offset = p1
      "#{p1}var #{p2} = void 0;\n" +
      "#{p1}var _#{p2}_ = #{DslFactory.source(offset, p2)}" +
      match.replace(p2, "_#{p2}_")

    describeReplacer = (match, p1)->
      match.replace(p1, "_#{p1}_") if p1?

    updateResult = ->
      pushToResult() if status.endOfLine?

    pushToResult = ->
      joined_line = line.join('')
      joined_line = joined_line.replace(/(\s*)(\w*)\.is\(.*/g, mainReplacer)
      joined_line = joined_line.replace(/.*(describe)\(.*/g, describeReplacer)
      joined_line = joined_line.replace(/.*([xfd]{1}describe)\(.*/g, describeReplacer)
      result_string.push(joined_line) and clearLine()

    returnCallback = ->
      # console.log result_string.join('')
      eval("(#{result_string.join('')});")

    endWrap = ->
      return unless status.endMatched?
      line.push '; }'

    beginWrap = ->
      return unless status.beginMatched?
      line.push 'function() { return '

    save = (char)-> line.push char

    analize = (char)->
      result = Analizer(char)
      status.endOfLine = result.endOfLineCheck()
      status.endMatched = result.endingCheck()
      status.beginMatched = result.beginningCheck()

    {
      push: (char)->
        analize char
        endWrap()
        save(char)
        beginWrap()
        updateResult()

      result: ->
        pushToResult()
        returnCallback()
    }
