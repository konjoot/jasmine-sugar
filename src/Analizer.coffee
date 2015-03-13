define 'Analizer', ['Dumper'], (_Dumper_)->

  (Dumper = _Dumper_())->
    status =
      pCount: 0
      inString: undefined
      escaped: undefined

    pCount = 0

    CharAnalizer = (char, strings = [])->
      unless char in ['\'', '"', '\\', '(', ')']
        return status

      if char == '\\'
        status.escaped = true
        return status

      if char.match(/'|"/)? && not status.escaped?
        if strings.indexOf(char) < 0
          strings.push char
          status.inString = true
        else
          strings.splice(strings.indexOf(char), 1)
          status.inString = strings.length > 0
      else if char == '(' and not status.inString?
        status.pCount += 1
      else if char == ')' and not status.inString?
        status.pCount -= 1

      status

    (char)->
      Dumper.push char
      aChar = CharAnalizer char

      {
        inDslParams: undefined

        endOfLineCheck: ->
          if not aChar.inString? and char == "\n"
            return true

          undefined

        beginningCheck: ->
          return undefined     if aChar.inString?
          return undefined     if @inDslParams?
          return undefined unless Dumper.last(4) == '.is('
          pCount = aChar.pCount
          @inDslParams = true

        endingCheck: ->
          return undefined     if aChar.inString?
          return undefined unless @inDslParams?
          return undefined unless char == ')'
          return undefined unless pCount == aChar.pCount
          @inDslParams = undefined
          true
      }

# old variant
# define 'Analizer', ['Dumper'], (_Dumper_)->

#   Dumper = _Dumper_()

#   statusObj = {
#     inString: undefined
#     endOfLine: undefined
#     inCallback: undefined
#     endMatched: undefined
#     inDSLParams: undefined
#     beginMatched: undefined
#     callbackBegins: undefined
#     resolved: undefined

#     reset: ->
#       @inString = undefined if @inString? and @inString == false
#       @resolved = undefined if @resolved?
#       @endOfLine = undefined if @endOfLine?
#       @endMatched = undefined if @endMatched?
#       @inDSLParams = undefined if @inDSLParams? and @inDSLParams == false
#       @beginMatched = undefined if @beginMatched?
#       @callbackBegins = undefined if @callbackBegins?

#     resolve: -> @resolved = true
#   }


#   (string = Dumper.buffer(), parentheses = [], strings = [])->

#     {
#       push: (char)->
#         Dumper.push char
#         @status.reset()
#         @updateStatus()

#       updateStatus: (str)->
#         str ||= @buffer()
#         @callbackBeginningCheck str.slice(-9)
#         @parenthesesCheck       str.slice(-1)
#         @endOfLineCheck         str.slice(-1)
#         @DslParamsCheck         str.slice(-4)
#         @stringCheck            str.slice(-1), str.substr(-2, 1)

#       callbackBeginningCheck: (str)->
#         return if @status.resolved?
#         return if @status.inCallback?
#         return unless str?
#         return unless str == 'tion () {'

#         @status.inCallback = true
#         @status.callbackBegins = true
#         @status.resolve()

#       parenthesesCheck: (char)->
#         return if @status.resolved?
#         return if @status.inString?
#         return unless @status.inDSLParams?
#         return unless char?
#         return unless char.match(/(|)/)?

#         parentheses.push(char) if char == '('
#         if char == ')'
#           @status.inDSLParams = parentheses.pop()
#           @status.endMatched = true unless @status.inDSLParams?
#         @status.resolve()

#       endOfLineCheck: (char)->
#         return if @status.resolved?
#         return if @status.inString?
#         return unless char?
#         return unless char == "\n"

#         @status.endOfLine = true
#         @status.resolve()

#       DslParamsCheck: (str)->
#         return if @status.resolved?
#         return unless str?
#         return unless str == '.is('

#         @status.inDSLParams = @status.beginMatched = true
#         @status.resolve()

#       stringCheck: (char, prev)->
#         return if @status.resolved?
#         return unless @status.inDSLParams?
#         return unless char? or prev?
#         return unless char.match(/'|"/)?
#         return if prev == "\\"
#         if strings.indexOf(char) < 0
#           strings.push char
#           @status.inString = true
#         else
#           strings.splice(strings.indexOf(char), 1)
#           @status.inString = strings.length > 0
#         @status.resolve()

#       buffer: -> Dumper.buffer()

#       status: statusObj

#     }
