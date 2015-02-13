define 'callbackWrapper', ['contextFactory', 'store', 'privateStore', 'jasmine'], (_ContextFactory_, _Store_, _Context_, _Jasmine_)->
  (fn, ContextFactory = _ContextFactory_, Store = _Store_, Context = _Context_, Jasmine = _Jasmine_)->

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
      inString       =
      endMatched     =
      inCallback     =
      inDSLParams    =
      beginMatched   =
      inParenthesis  =
      callbackBegins = undefined

      parentheses  = []
      strings      = []
      dstrings     = []

      dump = Dump()


      analize = (char)->
        dump.push char
        endMatched = undefined if endMatched?
        beginMatched = undefined if beginMatched?
        callbackBegins = undefined if callbackBegins?
        inDSLParams = undefined if inDSLParams? and inDSLParams == false
        inString = undefined if inString? and inString == false

        switch
          when dump.buffer() == '() {' and not inCallback?
            callbackBegins = inCallback = true
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
      DslObjectDefinitions = (for __object in @properties()
        "var #{__object};"
        "var _#{__object}_ = new (#{ContextFactory.toString()})('#{__object}', this);").join("\n")

      for char in fn.toString()
        analize char
        result.push(endWrap) if endMatched?
        result.push char
        result.push("\n#{DslObjectDefinitions}") if callbackBegins?
        result.push(beginWrap) if beginMatched?

      # console.log 'original'
      # console.log fn.toString()
      # console.log 'result'
      # console.log result.join('')

      func = result.join('')
      replacer = (match, p1, p2, p3, offset, string)->
        return match.replace(p1, "_#{p1}_") if p1?
        # console.log 'match'
        # console.log match
        # console.log 'p1'
        # console.log p1
        # console.log 'p2'
        # console.log p2
        # console.log 'p3'
        # console.log p3
        # console.log 'offset'
        # console.log offset
        # console.log 'string'
        # console.log string

      # eval "(#{result.join('')});"
      eval "(#{func.replace(/\n*(\w*)\.is\(.*/g, replacer)});"

    @run = do (properties = @properties(), fn = @prepareCallback())-> ->
      # (->
        # for __object in properties
        #   this[__object] = eval("(#{factorySource})('#{__object}')")
        #   eval("#{__object} = this.#{__object};")

        # Context.set this
        # fn.call(this)
      # ).call Context.get()
      # console.log fn.toString()
      fn.call Context.get()

    this

# working example
# func = ->
#   collection = (-> {is: -> console.log collection})() # here is ContextFactory
#   collection.is -> 'test'
#   console.log collection
# func()