define('Context', function() {
  var Context;
  Context = void 0;
  return function() {
    return function(value) {
      if (value == null) {
        return Context;
      }
      return Context = value;
    };
  };
});
