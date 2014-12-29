window.JasmineSugar = {} unless window.JasmineSugar

JasmineSugar.Interface = (Jasmine, Wrapper)->
  return {} unless Jasmine
  return {} unless Wrapper

  @it = ()->
    Jasmine.it.apply this, Wrapper(arguments).it()

  @iit = ()->
    Jasmine.iit.apply this, Wrapper(arguments).it()

  this