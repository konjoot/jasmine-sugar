define 'main', ['arguments', 'interface'], (ArgumentsWrapper, Interface)->
  {
    setup: (context)->
      Jasmine = try context.jasmine.getEnv() catch e
      return context unless Jasmine?

      Sugar = new Interface(Jasmine, ArgumentsWrapper)

      for key of Sugar when Sugar.hasOwnProperty(key) and Jasmine.hasOwnProperty(key)
        do (key = key)->
          context[key] = -> Sugar[key].apply(context, arguments)

      context
  }

require ['main'], (JasmineSugar) ->
  JasmineSugar.setup(this)
  this.JasmineSugar = JasmineSugar
  this
