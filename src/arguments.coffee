define 'arguments', ['utils'], (u)->
  ->
    args = [].slice.call(arguments)

    {
      it: ->
        args = args[0..1]

        [
          u(arg for arg in args when typeof(arg) is 'function').first(),
          u(arg for arg in u(args).cropFrom(this[0]) when typeof(arg) is 'string').first() || ' '
        ].reverse()

    }
