define 'main', ['arguments', 'interface', 'jasmine'], (ArgumentsWrapper, SugarInterface, JasmineStore)->
  {
    setup: (context)->
      Jasmine = try context.jasmine.getEnv() catch e
      return context unless Jasmine?

      JasmineStore = Jasmine

      Sugar = new SugarInterface(Jasmine, ArgumentsWrapper)

      for key of Sugar
        do (key = key)->
          context[key] = -> Sugar[key].apply(context, arguments)

      context
  }

require ['main'], (JasmineSugar) ->
  JasmineSugar.setup(this)
  this.JasmineSugar = JasmineSugar
  this
