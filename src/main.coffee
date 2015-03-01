define 'main', ['SugarInterface', 'Jasmine'], (SugarInterface, JasmineStore)->
  {
    setup: (context)->
      Jasmine = try context.jasmine.getEnv() catch e
      return context unless Jasmine?
      JasmineStore.set Jasmine

      for key of Sugar = new SugarInterface()
        do (key = key)->
          context[key] = -> Sugar[key].apply(context, arguments)

      context
  }

require ['main'], (JasmineSugar) ->
  JasmineSugar.setup(this)
  this.JasmineSugar = JasmineSugar
  this
