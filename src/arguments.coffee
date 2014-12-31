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
        args = args[0..2]

        fn = _(arg for arg in args when typeof(arg) is 'function').first()
        return args unless fn?

        args = _(args).without(fn).cropToEnd().result()
        descr = _(arg for arg in args when typeof(arg) is 'string').first()

        [descr || ' ', fn]

    }
