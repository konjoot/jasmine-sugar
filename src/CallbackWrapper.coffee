define 'CallbackWrapper', ['Store', 'PrivateStore', 'Jasmine', 'Evaluator'], (_Store_, _Context_, _Jasmine_, _Evaluator_)->
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
              eval("#{func.name} = func.evaluate();") for func in Store.failed[name]

          Jasmine.instance.afterEach ->
            eval("#{self.name} = void 0;")

            if Store.failed? and Store.failed[name]?
              eval("#{func.name} = void 0;") for func in Store.failed[name]

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
      inDescribe     =
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

        pushToResult = ->
          joined_line = line.join('')
          joined_line = joined_line.replace(/(\s*)(\w*)\.is\(.*/g, mainReplacer) if not inDescribe?
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
        endMatched = undefined if endMatched?
        endOfLine = undefined if endOfLine?
        beginMatched = undefined if beginMatched?
        callbackBegins = undefined if callbackBegins?
        inDSLParams = undefined if inDSLParams? and inDSLParams == false
        inDescribe = undefined if inDescribe? and inDescribe == false
        inString = undefined if inString? and inString == false

        switch
          when dump.buffer() == 'tion () {' and not inCallback?
            callbackBegins = inCallback = true
          when dump.buffer() == 'describe(' and not inDescribe?
            inDescribe = true
          when char == '(' and inDSLParams? and not inString? and not inDescribe?
            parentheses.push char
          when char == ')' and inDSLParams? and not inString? and not inDescribe?
            inDSLParams = parentheses.pop()
            endMatched = true unless inDSLParams?
          when char == '(' and inDescribe? and not inString?
            parentheses.push char
          when char == ')' and inDescribe? and not inString?
            inDescribe = parentheses.pop()
          when dump.buffer().substring(8) == "\n" and not inString?
            endOfLine = true
          when dump.buffer().substring(5) == '.is(' and not inDSLParams? and not inDescribe?
            inDSLParams = beginMatched = true
          when char.match(/'|"/)? and (inDSLParams? or inDescribe?) and strings.indexOf(char) < 0 and not dump.buffer(7) == "\\"
            strings.push(char)
            inString = true
          when char.match(/'|"/)? and (inDSLParams? or inDescribe?) and not dump.buffer(7) == "\\"
            strings.splice(strings.indexOf(char), 1)
            inString = strings.length > 0

      return '' unless fn?

      Result = ResultFormatter()

      beginWrap = 'function() { return '
      endWrap   = '; }'
      # DslObjectDefinitions = (for __object in @properties()
      #   "var #{__object} = void 0;\n" +
      #   "var _#{__object}_ = new (#{ContextFactory.toString()})('#{__object}');").join("\n")

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
      #     .perhaps.insertATrailingWrap()
      #     .anyway.save()
      #     .perhaps.insertDslObjects()
      #     .perhaps.insertAnOpeningWrap()

      ################################# debug
      # res = eval "(#{Result.result()});"
      # console.log res.toString()
      # res
      # console.log Result.result()
      eval "(#{Result.result()});"

    @run = ->
      @prepareCallback().call Context.get()

    this


# Error
# name: ReferenceError
# message: 'collection is not defined'

# TODO: prevent double wrap of inner describes
