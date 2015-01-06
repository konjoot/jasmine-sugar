define('main', ['arguments', 'interface'], function(ArgumentsWrapper, Interface) {
  return {
    setup: function(context) {
      var Jasmine, Sugar, e, key;
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
      Sugar = new Interface(Jasmine, ArgumentsWrapper);
      for (key in Sugar) {
        if (Sugar.hasOwnProperty(key) && Jasmine.hasOwnProperty(key)) {
          (function(key) {
            return context[key] = function() {
              return Sugar[key].apply(context, arguments);
            };
          })(key);
        }
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
