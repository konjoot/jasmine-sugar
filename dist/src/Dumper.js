define('Dumper', function() {
  return function(size, dump) {
    if (size == null) {
      size = 9;
    }
    if (dump == null) {
      dump = [];
    }
    return (function() {
      return {
        push: function(val) {
          if (dump.push(val) > size) {
            return dump.shift();
          }
        },
        buffer: function() {
          return dump.join('');
        }
      };
    })();
  };
});
