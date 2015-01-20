define 'callback', ['contextFactory'], (DefaultContextFactory)->
  (fn, ContextFactory = DefaultContextFactory)->

    factorySource = (prop)-> new ContextFactory(prop)

    @properties = do ->
      -> ['collection']

    # @PreparedContext = do (properties = @properties())->
    #   context = new Context()

    #   for prop in properties
    #     context.defineProperty(prop)

    #   -> context

    @run = ->
      do (properties = @properties())->
        for obj in properties
          eval('var ' + obj + ' = (' + factorySource.toString() + ')(' + '"' + obj + '"' + ');')

        eval('(' + fn.toString() + ')')()

    this