define('Store', function() {
  var privateStore;
  if (typeof privateStore === "undefined" || privateStore === null) {
    privateStore = {};
  }
  return function(store) {
    if (store != null) {
      privateStore = store;
    }
    return privateStore;
  };
});
