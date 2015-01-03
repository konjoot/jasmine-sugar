define ['sugar'], (JasmineSugar)->
  do (context = this)->
    JasmineSugar.setup(context)
    context.JasmineSugar = JasmineSugar
    context
