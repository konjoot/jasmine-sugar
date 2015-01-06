define ->
  (Jasmine, Wrapper)->
    return {} unless Jasmine
    return {} unless Wrapper

    methods = ['it', 'iit', 'fit', 'xit']

    for method in methods
      this[method] = do (method = method)->
        ->
          Jasmine[method].apply(this,
            Wrapper(arguments...).it())

    # genarating the following functions:
    # @it = ()->
    #   Jasmine.it.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    # @iit = ()->
    #   Jasmine.iit.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    # @fit = ()->
    #   Jasmine.fit.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    # @xit = ()->
    #   Jasmine.xit.apply(
    #     this,
    #     Wrapper(arguments...).it()
    #   )

    this