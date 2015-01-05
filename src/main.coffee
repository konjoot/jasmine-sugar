define ['sugar'], (JasmineSugar)->
  # version 0.0.2
  do (context = this)->
    JasmineSugar.setup(context)
    context.JasmineSugar = JasmineSugar
    context
