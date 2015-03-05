define('Analizer', ['Dumper'], function(_Dumper_) {
  return function(Dumper) {
    var callbackBegins, inCallback, inDSLParams, inParenthesis, inString, parentheses, strings;
    if (Dumper == null) {
      Dumper = _Dumper_();
    }
    inString = inCallback = inDSLParams = inParenthesis = callbackBegins = void 0;
    parentheses = [];
    strings = [];
    return {
      push: function(char) {
        Dumper.push(char);
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
          case !(Dumper.buffer() === 'tion () {' && (inCallback == null)):
            return callbackBegins = inCallback = true;
          case !(char === '(' && (inDSLParams != null) && (inString == null)):
            return parentheses.push(char);
          case !(char === ')' && (inDSLParams != null) && (inString == null)):
            inDSLParams = parentheses.pop();
            if (inDSLParams == null) {
              return this.endMatched = true;
            }
            break;
          case !(Dumper.buffer().substring(8) === "\n" && (inString == null)):
            return this.endOfLine = true;
          case !(Dumper.buffer().substring(5) === '.is(' && (typeof inDescribe === "undefined" || inDescribe === null)):
            return inDSLParams = this.beginMatched = true;
          case !((char.match(/'|"/) != null) && (inDSLParams != null) && strings.indexOf(char) < 0 && !Dumper.buffer(7) === "\\"):
            strings.push(char);
            return inString = true;
          case !((char.match(/'|"/) != null) && (inDSLParams != null) && !Dumper.buffer(7) === "\\"):
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
