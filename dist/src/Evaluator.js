define('Evaluator', ['Store'], function(_Store_) {
  return function(Store) {
    var callWithPreparedContext, catcher, properties, self;
    if (Store == null) {
      Store = _Store_;
    }
    self = void 0;
    if (typeof properties === "undefined" || properties === null) {
      properties = {};
    }
    callWithPreparedContext = function() {
      var __name, __val;
      for (__name in properties) {
        __val = properties[__name];
        eval("var " + __name + " = __val;");
      }
      return properties[self.name] = eval("(" + (self.func.toString()) + ")();");
    };
    catcher = function(e) {
      var dependency, _base;
      if (e.name !== 'ReferenceError') {
        return;
      }
      dependency = e.message.match(/^(\w+).*$/)[1];
      Store.failed || (Store.failed = {});
      (_base = Store.failed)[dependency] || (_base[dependency] = {});
      Store.failed[dependency][self.name] = self;
      return void 0;
    };
    return {
      perform: function(obj) {
        var e;
        self = obj;
        try {
          return callWithPreparedContext();
        } catch (_error) {
          e = _error;
          return catcher(e);
        }
      },
      flush: function(name) {
        var e;
        try {
          delete properties[name];
          return delete Store.failed[name];
        } catch (_error) {
          e = _error;
          return catcher(e);
        }
      }
    };
  };
});
