define('interface', function() {
  return function(Jasmine, Wrapper) {
    var method, methods, _i, _len;
    if (!Jasmine) {
      return {};
    }
    if (!Wrapper) {
      return {};
    }
    methods = ['it', 'iit', 'fit', 'xit'];
    for (_i = 0, _len = methods.length; _i < _len; _i++) {
      method = methods[_i];
      this[method] = (function(method) {
        return function() {
          return Jasmine[method].apply(this, Wrapper.apply(null, arguments).it());
        };
      })(method);
    }
    return this;
  };
});
