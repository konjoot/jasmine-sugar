define 'EventMachine', ['Utils'], (u)->
  triggers = {} unless triggers?

  (name, value)->
    get = (name)-> eval name

    # ability to redefine private functions, and variables
    if name? && arguments.length > 1
      return eval("#{name} = #{eval(value)};") unless value?
      # return eval("#{name} = value;") if u(value).isAFunction()
      return eval("#{name} = value;")

    # allow access to private methods and variables by name
    if name?
      return prop if u(prop = eval(name)).isAFunction()
      return -> get(name)

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
