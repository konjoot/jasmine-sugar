define 'context', ->
  (PrivateContext, ContextFactory)->
    PrivateContext ||= {}

    @defineProperty = (prop)->
      return false unless prop?

      PrivateContext[prop] = (prop)-> new ContextFactory(prop)

      return true if PrivateContext[prop]?
      false

    @properties = PrivateContext

    this

