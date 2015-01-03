define(function() {
  return function(Jasmine, Wrapper) {
    if (!Jasmine) {
      return {};
    }
    if (!Wrapper) {
      return {};
    }
    this.it = function() {
      console.log('it');
      return Jasmine.it.apply(this, Wrapper.apply(null, arguments).it());
    };
    this.iit = function() {
      return Jasmine.iit.apply(this, Wrapper.apply(null, arguments).it());
    };
    this.fit = function() {
      return Jasmine.fit.apply(this, Wrapper.apply(null, arguments).it());
    };
    this.xit = function() {
      return Jasmine.xit.apply(this, Wrapper.apply(null, arguments).it());
    };
    return this;
  };
});
