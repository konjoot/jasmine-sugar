define('Analizer', function() {
  return function() {
    var Dump, callbackBegins, dump, inCallback, inDSLParams, inParenthesis, inString, parentheses, strings;
    inString = inCallback = inDSLParams = inParenthesis = callbackBegins = void 0;
    parentheses = [];
    strings = [];
    Dump = function(size) {
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
    dump = Dump();
    return {
      push: function(char) {
        dump.push(char);
        if ((inString != null) && inString === false) {
          inString = void 0;
        }
        if (this.endOfLine != null) {
          this.endOfLine = void 0;
        }
        if (this.endMatched != null) {
          this.endMatched = void 0;
        }
        if ((inDSLParams != null) && inDSLParams === false) {
          inDSLParams = void 0;
        }
        if (this.beginMatched != null) {
          this.beginMatched = void 0;
        }
        if (callbackBegins != null) {
          callbackBegins = void 0;
        }
        switch (false) {
          case !(dump.buffer() === 'tion () {' && (inCallback == null)):
            return callbackBegins = inCallback = true;
          case !(char === '(' && (inDSLParams != null) && (inString == null)):
            return parentheses.push(char);
          case !(char === ')' && (inDSLParams != null) && (inString == null)):
            inDSLParams = parentheses.pop();
            if (inDSLParams == null) {
              return this.endMatched = true;
            }
            break;
          case !(dump.buffer().substring(8) === "\n" && (inString == null)):
            return this.endOfLine = true;
          case !(dump.buffer().substring(5) === '.is(' && (typeof inDescribe === "undefined" || inDescribe === null)):
            return inDSLParams = this.beginMatched = true;
          case !((char.match(/'|"/) != null) && (inDSLParams != null) && strings.indexOf(char) < 0 && !dump.buffer(7) === "\\"):
            strings.push(char);
            return inString = true;
          case !((char.match(/'|"/) != null) && (inDSLParams != null) && !dump.buffer(7) === "\\"):
            strings.splice(strings.indexOf(char), 1);
            return inString = strings.length > 0;
        }
      },
      endOfLine: void 0,
      endMatched: void 0,
      beginMatched: void 0
    };
  };
});
