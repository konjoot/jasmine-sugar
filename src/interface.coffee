root = exports ? this
root.JasmineSugar = JasmineSugar ? {}


JasmineSugar.Interface = (Jasmine, Wrapper)->
  return {} unless Jasmine
  return {} unless Wrapper

  @it = ()->
    Jasmine.it.apply(
      this,
      Wrapper.apply(this, [].slice.call(arguments)).it()
    )

  @iit = ()->
    Jasmine.iit.apply(
      this,
      Wrapper.apply(this, [].slice.call(arguments)).it()
    )

  this