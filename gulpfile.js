var gulp = require('gulp');
var karma = require('karma').server;
var colors = require('colors');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');

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

gulp.task('coffee', function() {
  gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist/src'))
});