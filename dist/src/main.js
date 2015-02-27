define('main', ['ArgumentsWrapper', 'SugarInterface'], function(ArgumentsWrapper, SugarInterface) {
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
      Sugar = new SugarInterface(Jasmine, ArgumentsWrapper);
      _fn = function(key) {
        return context[key] = function() {
          return Sugar[key].apply(context, arguments);
        };
      };
      for (key in Sugar) {
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
