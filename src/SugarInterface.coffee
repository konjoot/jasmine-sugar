define 'SugarInterface', ['ArgumentsWrapper', 'Jasmine', 'Context', 'Utils'], (_ArgumentsWrapper_, _Jasmine_, _Context_, _u_)->
  (Wrapper = _ArgumentsWrapper_(), Jasmine = _Jasmine_, Context = _Context_(), u = _u_)->
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
            Jasmine.instance[method].apply(Context(this),
              Wrapper(arguments...).describe())

        this["_#{method}_"] = do (method = method)->
          ->
            Jasmine.instance[method].apply(Context(this),
              Wrapper(arguments...)._describe_())

    this