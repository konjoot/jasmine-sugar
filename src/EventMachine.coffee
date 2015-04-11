define 'EventMachine', ['Utils'], (u)->
  triggers ||= {}

  (name)->

    {
      emitWith: ->
        for trigger in triggers[name] when u(trigger).isAFunction()
          trigger.apply(this, arguments)

      triggers: ->
        for trigger in arguments when u(trigger).isAFunction()
          triggers[name] ||= []
          triggers[name].push(trigger)

      reset: ->
        triggers[name] = []
    }
