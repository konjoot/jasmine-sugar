root = exports ? this
root.JasmineSugar = JasmineSugar ? {}

JasmineSugar.Arguments = =>
  ->
    _ = JasmineSugar.Utils
    args = [].slice.call(arguments)

    isEmpty = ->
      for arg in args
        return false
      true

    {
      it: ->
        args[0..2]

        fn = arg for arg in args when typeof(arg) is 'function'
        return args unless fn?

        _(args).without(fn).cropToEnd()

        descr = arg for arg in args when typeof(arg) is 'string'
        descr ?= ' '

        [descr, fn]

    }
