define 'ArgumentsWrapper', ['Utils', 'CallbackWrapper'], (_u_, _Callback_)->
  (u = _u_, Callback = _Callback_)->
    ->
      args = [].slice.call(arguments)

      {
        it: ->
          args = args[0..1]

          [
            u(arg for arg in args when u(arg).isAFunction()).first(),
            u(arg for arg in u(args).cropFrom(this[0]) when u(arg).isAString()).first() || ' '
          ].reverse()

        describe: ->
          fn = u(arg for arg in args[0..1] when u(arg).isAFunction()).first()

          [
            u(arg for arg in u(args[0..1]).cropFrom(fn) when u(arg).isAString()).first(),
            -> (new Callback(fn)).run()
          ]

        _describe_: ->
          args = args[0..1]

          [
            u(arg for arg in args when u(arg).isAFunction()).first(),
            u(arg for arg in u(args).cropFrom(this[0]) when u(arg).isAString()).first() || ' '
          ].reverse()
      }
