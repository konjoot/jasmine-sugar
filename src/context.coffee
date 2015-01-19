define 'context', ['contextFactory'], (DefaultFactory)->
  (ContextFactory, PrivateContext)->
    PrivateContext ||= {}
    ContextFactory ||= DefaultFactory

    @defineProperty = (prop)->
      return false unless prop?

      PrivateContext[prop] = (prop)-> new ContextFactory(prop)

      return true if PrivateContext[prop]?
      false

    @properties = PrivateContext

    this

