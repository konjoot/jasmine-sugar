define 'SugarInterface', ['ArgumentsWrapper', 'Jasmine', 'Context', 'Utils'], (Wrapper, Jasmine, Context, u)->
  ->
    return {} unless Jasmine.instance?

    for method in ['it', 'iit', 'fit', 'xit']
      if u(Jasmine.instance[method]).isAFunction()
        this[method] = do (method = method)->
          ->
            Jasmine.instance[method].apply(this,
              Wrapper(arguments...).it())

    for method in ['describe', 'fdescribe', 'xdescribe', 'ddescribe']
      if u(Jasmine.instance[method]).isAFunction()
        this[method] = do (method = method)->
          ->
            Jasmine.instance[method].apply(Context.set(this),
              Wrapper(arguments...).describe())

        this["_#{method}_"] = do (method = method)->
          ->
            Jasmine.instance[method].apply(Context.set(this),
              Wrapper(arguments...)._describe_())

    this