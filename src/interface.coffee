root = exports ? this
root.JasmineSugar = JasmineSugar ? {}


JasmineSugar.Interface = (Jasmine, Wrapper)->
  return {} unless Jasmine
  return {} unless Wrapper

  @it = ()->
    Jasmine.it.apply(
      this,
      Wrapper(arguments...).it()
    )

  @iit = ()->
    Jasmine.iit.apply(
      this,
      Wrapper(arguments...).it()
    )

  @fit = ()->
    Jasmine.fit.apply(
      this,
      Wrapper(arguments...).it()
    )

  @xit = ()->
    Jasmine.xit.apply(
      this,
      Wrapper(arguments...).it()
    )

  this