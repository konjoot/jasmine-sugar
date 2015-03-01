define('Context', function() {
  var Context;
  Context = void 0;
  return {
    set: function(value) {
      return Context = value;
    },
    get: function() {
      return Context;
    }
  };
});
