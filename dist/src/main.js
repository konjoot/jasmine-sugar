define(['sugar'], function(JasmineSugar) {
  return (function(context) {
    JasmineSugar.setup(context);
    context.JasmineSugar = JasmineSugar;
    return context;
  })(this);
});
