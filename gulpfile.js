var gulp = require('gulp');
var karma = require('karma').server;
var colors = require('colors');

/**
 * Run test once and exit
 */
gulp.task('test', function (done) {
  karma.start({
    configFile: __dirname + '/karma.conf.js',
    singleRun: true
  }, function(exitStatus){
    if (exitStatus > 0){
      console.log('It fail!!!'.yellow.bgRed.bold);
    }
  });
});
