define('SugarInterface', ['ArgumentsWrapper', 'Jasmine', 'Context', 'Utils'], function(Wrapper, Jasmine, Context, u) {
  return function() {
    var method, _i, _j, _len, _len1, _ref, _ref1;
    if (Jasmine.instance == null) {
      return {};
    }
    _ref = ['it', 'iit', 'fit', 'xit'];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      method = _ref[_i];
      if (u(Jasmine.instance[method]).isAFunction()) {
        this[method] = (function(method) {
          return function() {
            return Jasmine.instance[method].apply(this, Wrapper.apply(null, arguments).it());
          };
        })(method);
      }
    }
    _ref1 = ['describe', 'fdescribe', 'xdescribe', 'ddescribe'];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      method = _ref1[_j];
      if (u(Jasmine.instance[method]).isAFunction()) {
        this[method] = (function(method) {
          return function() {
            return Jasmine.instance[method].apply(Context.set(this), Wrapper.apply(null, arguments).describe());
          };
        })(method);
        this["_" + method + "_"] = (function(method) {
          return function() {
            return Jasmine.instance[method].apply(Context.set(this), Wrapper.apply(null, arguments)._describe_());
          };
        })(method);
      }
    }
    return this;
  };
});
