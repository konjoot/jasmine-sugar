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

      replacer = (match, p1, p2, p3, offset, string)->
        return match.replace(p1, "_#{p1}_") if p1?

      analize = (char)->
        dump.push char
        endMatched = undefined if endMatched?
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
          when dump.buffer().substring(5) == '.is(' and not inDSLParams? and not inDescribe?
            inDSLParams = beginMatched = true
          when char.match(/'|"/)? and (inDSLParams? or inDescribe?) and strings.indexOf(char) < 0 and not dump.buffer(7) == "\\"
            strings.push(char)
            inString = true
          when char.match(/'|"/)? and (inDSLParams? or inDescribe?) and not dump.buffer(7) == "\\"
            strings.splice(strings.indexOf(char), 1)
            inString = strings.length > 0

      return '' unless fn?
      result = []
      beginWrap = 'function() { return '
      endWrap   = '; }'
      DslObjectDefinitions = (for __object in @properties()
        "var #{__object} = void 0;\n" +
        "var _#{__object}_ = new (#{ContextFactory.toString()})('#{__object}');").join("\n")

      for char in fn.toString()
        analize char
        result.push(endWrap) if endMatched?
        result.push char
        result.push("\n#{DslObjectDefinitions}") if callbackBegins?
        result.push(beginWrap) if beginMatched?

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
      res = eval "(#{result.join('').replace(/\n*(\w*)\.is\(.*/g, replacer)});"
      console.log res.toString()
      res
      # eval "(#{result.join('').replace(/\n*(\w*)\.is\(.*/g, replacer)});"

    @run = ->
      @prepareCallback().call Context.get()

    this


# Error
# name: ReferenceError
# message: 'collection is not defined'

# TODO: prevent double wrap of inner describes
