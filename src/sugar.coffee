module.exports = ->
  JasmineSugar = (context)->
    jasmine = (context && context.jasmine) || {}

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
