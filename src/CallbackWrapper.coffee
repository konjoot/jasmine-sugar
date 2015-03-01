define 'CallbackWrapper', ['Store', 'Context', 'Jasmine', 'Evaluator'], (_Store_, _Context_, _Jasmine_, _Evaluator_)->
  (fn, Store = _Store_, Context = _Context_, Jasmine = _Jasmine_, Evaluator = _Evaluator_)->

    evaluator = new Evaluator()

    Dump = (size = 9)->
      dump = []

      {
        push: (val)->
          dump.shift() if dump.push(val) > size

        buffer: (index)->
          return dump.join('') unless index?
          dump.join('')[index]
      }

    ContextFactory = (name)->
      self = undefined
      name = name

      {
        is: (argsFunction)->
          return unless argsFunction?
          self = this
          self.name = name
          self.func = argsFunction

          Jasmine.instance.beforeEach ->
            eval("#{self.name} = self.evaluate();")

            if Store.failed? and Store.failed[name]?
              eval("#{__func.name} = __func.evaluate();") for _, __func of Store.failed[name]

          Jasmine.instance.afterEach ->
            eval("#{self.name} = void 0;")

            if Store.failed? and Store.failed[name]?
              for _, __func of Store.failed[name]
                eval("#{__func.name} = void 0;")
                evaluator.flush __func.name

            evaluator.flush self.name

        evaluate: -> evaluator.perform(self)

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

      dump = Dump()


      ResultFormatter = ->
        result_string = []
        line = []
        offset = ''

        clearLine = -> line = []

        factoryReplacer = (match, p1)->
          return unless p1?
          return match if p1.length < 1
          match.replace(p1, p1 + offset)

        mainReplacer = (match, p1, p2)->
          return unless p1? && p2?
          offset = p1
          "#{p1}var #{p2} = void 0;\n" +
          "#{p1}var _#{p2}_ = new (#{ContextFactory.toString().replace(/(\s*){1}.*/g, factoryReplacer)})('#{p2}');\n" +
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
            line.push(char)
            pushToResult() if endOfLine?

          result: ->
            pushToResult()
            result_string.join('')
        }

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

      return '' unless fn?

      Result = ResultFormatter()

      beginWrap = 'function() { return '
      endWrap   = '; }'

      for char in fn.toString()
        analize char
        Result.push(endWrap) if endMatched?
        Result.push char
        Result.push(beginWrap) if beginMatched?

      # planning refactoring
      # analize = (char)->
      #   new Analizer

      # for char in fn.toString()
      #   analize(char)
      #     .insertATrailingWrap()
      #     .save()
      #     .insertDslObjects()
      #     .insertAnOpeningWrap()

      eval("(#{Result.result()});")

    @run = ->
      @prepareCallback().call Context.get()

    this


# Error
# name: ReferenceError
# message: 'collection is not defined'
