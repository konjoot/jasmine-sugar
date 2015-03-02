define('ContextFactory', function() {
  return function(name, Evaluator, Jasmine) {
    var self;
    self = void 0;
    name = name;
    return {
      is: function(argsFunction) {
        if (argsFunction == null) {
          return;
        }
        self = this;
        self.name = name;
        self.func = argsFunction;
        Jasmine.instance.beforeEach(function() {
          var _, __func, _ref, _results;
          eval("" + self.name + " = self.evaluate();");
          if ((Store.failed != null) && (Store.failed[name] != null)) {
            _ref = Store.failed[name];
            _results = [];
            for (_ in _ref) {
              __func = _ref[_];
              _results.push(eval("" + __func.name + " = __func.evaluate();"));
            }
            return _results;
          }
        });
        return Jasmine.instance.afterEach(function() {
          var _, __func, _ref;
          eval("" + self.name + " = void 0;");
          if ((Store.failed != null) && (Store.failed[name] != null)) {
            _ref = Store.failed[name];
            for (_ in _ref) {
              __func = _ref[_];
              eval("" + __func.name + " = void 0;");
              Evaluator.flush(__func.name);
            }
          }
          return Evaluator.flush(self.name);
        });
      },
      evaluate: function() {
        return Evaluator.perform(self);
      }
    };
  };
});
