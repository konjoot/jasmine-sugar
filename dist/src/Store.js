define('Store', function() {
  var privateStore;
  privateStore = {};
  return function(store) {
    if (store != null) {
      privateStore = store;
    }
    return privateStore;
  };
});
