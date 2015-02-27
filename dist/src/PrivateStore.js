define('PrivateStore', function() {
  var PrivateStore;
  PrivateStore = void 0;
  return {
    set: function(value) {
      return PrivateStore = value;
    },
    get: function() {
      return PrivateStore;
    }
  };
});
