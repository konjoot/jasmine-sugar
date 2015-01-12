define 'interface', ->
  (Jasmine, Wrapper)->
    return {} unless Jasmine
    return {} unless Wrapper

    currentContext  =
    currentCallback = undefined

    # @set = ->
      # try
      #   callback.apply(this)
      # catch e
      #   switch e.name
      #     when 'ReferenceError'
      #       newCallback = new CallbackWrapper(callback)
      #       newCallback.apply(this)

    @set = (callback)->
      currentCallback = callback
      currentContext  = this

      runCallback().with preparedContext()

    runCallback = ->
      with: (context)->
        console.log 'before applying context'
        console.log context
        console.log currentCallback.toString()
        console.log eval(new Function('currentCallback', "console.log(currentCallback.toString());"), context)()
        console.log 'after applying context'
        context.clear()
        console.log context

    preparedContext = ->
      console.log "preparing context"
      assignedProperties = []
      # console.log "props #{callbackProperties()}"
      for prop in callbackProperties()
        console.log 'in property loop'
        if defineProperty prop
          assignedProperties.push(prop)

      console.log 'after property loop'
      currentContext.clear = ->
        for prop in assignedProperties
          delete currentContext[prop]

      currentContext

    callbackProperties = ->
      console.log currentCallback.toString()
      ['collection']

    defineProperty = (prop)->
      console.log "defining #{prop}"
      currentContext[prop] =
        letBe: (fn)->
          console.log "#{prop} defined"

    autoGeneratedMethods = ['it', 'iit', 'fit', 'xit']

    # genarating the following functions:
    # @it = ()->
    #   Jasmine.it.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    # @iit = ()->
    #   Jasmine.iit.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    # @fit = ()->
    #   Jasmine.fit.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    # @xit = ()->
    #   Jasmine.xit.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    for method in autoGeneratedMethods
      if Jasmine.hasOwnProperty(method) and typeof(Jasmine[method]) == 'function'
        this[method] = do (method = method)->
          ->
            Jasmine[method].apply(this,
              Wrapper(arguments...).it())

    this