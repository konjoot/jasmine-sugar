define 'callback', ['context'], (Context)->
  (fn)->
    properties = do ->
      ['collection']

    PreparedContext = do ->
      context = new Context()

      for prop in properties
        context.defineProperty(prop)

      context

    @run = ->
      do (context = PreparedContext)->
        for obj of context.properties
          eval('var ' + obj + ' = (' + context.properties[obj].toString() + ')(' + '"' + obj + '"' + ');')

        eval('(' + fn.toString() + ')')()

    this