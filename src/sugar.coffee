module.exports = do ->
  JasmineSugar = (context, call_wrapper)->
    CallWrapper = call_wrapper || require('./jasmineCallWrapper')
    jasmine = (context && context.jasmine) || {}
    Caller = new CallWrapper(jasmine)

    parsed = (args)->
      description = (typeof(args[0]) == 'string' && args[0]) || ' '
      fn = switch typeof(args[0])
        when 'function'
          args[0]
      fn ||= switch typeof(args[1])
        when 'function'
          args[1]

      [description, fn]

    @it = ()->
      args = [].slice.call(arguments)
      jasmine.it.apply(this, parsed(args))

    @iit = ()->
      args = [].slice.call(arguments)
      jasmine.iit.apply(this, parsed(args))

    this
