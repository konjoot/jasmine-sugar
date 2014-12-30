root = exports ? this
root.JasmineSugar = JasmineSugar ? {}

JasmineSugar.Arguments = =>
  ->
    args = [].slice.call(arguments)

    isEmpty = ->
      for arg in args
        return false
      true

    {
      it: ->
        switch args.length
          when 1
            args.unshift(' ')
            args
          when 2
            if typeof(args[0]) == 'function'
              return [ ' ', args[0] ]
            args
          else
            args

    }
