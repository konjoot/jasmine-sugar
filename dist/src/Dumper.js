define('Dumper', function() {
  return function(size) {
    var dump;
    if (size == null) {
      size = 9;
    }
    dump = [];
    return {
      push: function(val) {
        if (dump.push(val) > size) {
          return dump.shift();
        }
      },
      buffer: function(index) {
        if (index == null) {
          return dump.join('');
        }
        return dump.join('')[index];
      }
    };
  };
});
