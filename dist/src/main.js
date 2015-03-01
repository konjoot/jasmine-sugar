define('main', ['SugarInterface', 'Jasmine'], function(SugarInterface, JasmineStore) {
  return {
    setup: function(context) {
      var Jasmine, Sugar, e, key, _fn;
      Jasmine = (function() {
        try {
          return context.jasmine.getEnv();
        } catch (_error) {
          e = _error;
        }
      })();
      if (Jasmine == null) {
        return context;
      }
      JasmineStore.set(Jasmine);
      _fn = function(key) {
        return context[key] = function() {
          return Sugar[key].apply(context, arguments);
        };
      };
      for (key in Sugar = new SugarInterface()) {
        _fn(key);
      }
      return context;
    }
  };
});

require(['main'], function(JasmineSugar) {
  JasmineSugar.setup(this);
  this.JasmineSugar = JasmineSugar;
  return this;
});
