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

        [
          _(arg for arg in args when typeof(arg) is 'function').first(),
          _(arg for arg in _(args).cropFrom(this[0]) when typeof(arg) is 'string').first() || ' '
        ].reverse()

    }
