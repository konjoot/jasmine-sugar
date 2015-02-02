define 'arguments', ['utils', 'callback'], (u, Callback)->
  ->
    args = [].slice.call(arguments)

    {
      it: ->
        args = args[0..1]

        [
          u(arg for arg in args when u(arg).isAFunction()).first(),
          u(arg for arg in u(args).cropFrom(this[0]) when u(arg).isAString()).first() || ' '
        ].reverse()

      describe: (context)->
        args = args[0..1]

        fn = u(arg for arg in args when u(arg).isAFunction()).first()
        console.log 'in wrapper'
        [
          u(arg for arg in u(args).cropFrom(fn) when u(arg).isAString()).first(),
          (new Callback(fn)).run.call(context)
        ]

    }
