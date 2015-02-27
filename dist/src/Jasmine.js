define('Jasmine', function() {
  var Jasmine;
  if (typeof Jasmine === "undefined" || Jasmine === null) {
    Jasmine = void 0;
  }
  return {
    instance: (function(Jasmine) {
      return Jasmine;
    })(Jasmine),
    set: function(value) {
      return this.instance = Jasmine = value;
    },
    defined: function() {
      return Jasmine != null;
    }
  };
});
