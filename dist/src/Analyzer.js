define('Analyzer', ['Dumper'], function(_Dumper_) {
  var Dumper, statusObj;
  Dumper = _Dumper_();
  statusObj = {
    inString: void 0,
    endOfLine: void 0,
    inCallback: void 0,
    endMatched: void 0,
    inDSLParams: void 0,
    beginMatched: void 0,
    callbackBegins: void 0,
    resolved: void 0,
    reset: function() {
      if ((this.inString != null) && this.inString === false) {
        this.inString = void 0;
      }
      if (this.resolved != null) {
        this.resolved = void 0;
      }
      if (this.endOfLine != null) {
        this.endOfLine = void 0;
      }
      if (this.endMatched != null) {
        this.endMatched = void 0;
      }
      if ((this.inDSLParams != null) && this.inDSLParams === false) {
        this.inDSLParams = void 0;
      }
      if (this.beginMatched != null) {
        this.beginMatched = void 0;
      }
      if (this.callbackBegins != null) {
        return this.callbackBegins = void 0;
      }
    },
    resolve: function() {
      return this.resolved = true;
    }
  };
  return function(string, parentheses, strings) {
    if (string == null) {
      string = Dumper.buffer();
    }
    if (parentheses == null) {
      parentheses = [];
    }
    if (strings == null) {
      strings = [];
    }
    return {
      push: function(char) {
        Dumper.push(char);
        this.status.reset();
        return this.updateStatus();
      },
      updateStatus: function(str) {
        str || (str = this.buffer());
        this.callbackBeginningCheck(str.slice(-9));
        this.parenthesesCheck(str.slice(-1));
        this.endOfLineCheck(str.slice(-1));
        this.DslParamsCheck(str.slice(-4));
        return this.stringCheck(str.slice(-1), str.substr(-2, 1));
      },
      callbackBeginningCheck: function(str) {
        if (this.status.resolved != null) {
          return;
        }
        if (this.status.inCallback != null) {
          return;
        }
        if (str == null) {
          return;
        }
        if (str !== 'tion () {') {
          return;
        }
        this.status.inCallback = true;
        this.status.callbackBegins = true;
        return this.status.resolve();
      },
      parenthesesCheck: function(char) {
        if (this.status.resolved != null) {
          return;
        }
        if (this.status.inString != null) {
          return;
        }
        if (this.status.inDSLParams == null) {
          return;
        }
        if (char == null) {
          return;
        }
        if (char.match(/(|)/) == null) {
          return;
        }
        if (char === '(') {
          parentheses.push(char);
        }
        if (char === ')') {
          this.status.inDSLParams = parentheses.pop();
          if (this.status.inDSLParams == null) {
            this.status.endMatched = true;
          }
        }
        return this.status.resolve();
      },
      endOfLineCheck: function(char) {
        if (this.status.resolved != null) {
          return;
        }
        if (this.status.inString != null) {
          return;
        }
        if (char == null) {
          return;
        }
        if (char !== "\n") {
          return;
        }
        this.status.endOfLine = true;
        return this.status.resolve();
      },
      DslParamsCheck: function(str) {
        if (this.status.resolved != null) {
          return;
        }
        if (str == null) {
          return;
        }
        if (str !== '.is(') {
          return;
        }
        this.status.inDSLParams = this.status.beginMatched = true;
        return this.status.resolve();
      },
      stringCheck: function(char, prev) {
        if (this.status.resolved != null) {
          return;
        }
        if (this.status.inDSLParams == null) {
          return;
        }
        if (!((char != null) || (prev != null))) {
          return;
        }
        if (char.match(/'|"/) == null) {
          return;
        }
        if (prev === "\\") {
          return;
        }
        if (strings.indexOf(char) < 0) {
          strings.push(char);
          this.status.inString = true;
        } else {
          strings.splice(strings.indexOf(char), 1);
          this.status.inString = strings.length > 0;
        }
        return this.status.resolve();
      },
      buffer: function() {
        return Dumper.buffer();
      },
      status: statusObj
    };
  };
});
