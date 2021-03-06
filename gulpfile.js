var gulp = require('gulp'),
    karma = require('karma').server,
    colors = require('colors'),
    coffee = require('gulp-coffee'),
    gutil = require('gulp-util'),
    requirejs = require('requirejs'),
    del = require('del');

/**
 * Run test once and exit
 */
gulp.task('karma', ['coffee_test'], function (done) {
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
  var stream = gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./dist/src'));

  return stream
});

gulp.task('coffee_test', function() {
  var stream = gulp.src('./src/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('./test/src'));

  return stream
});


gulp.task('build', ['coffee'], function(done) {
  requirejs.optimize({
    'name': 'main',
    'findNestedDependencies': true,
    'baseUrl': './dist/src',
    'optimize': 'none',
    'out': './dist/jasmine-sugar.js',
    'onModuleBundleComplete': function(data) {
      var fs = require('fs'),
          amdclean = require('amdclean'),
          outputFile = data.path;

      fs.writeFileSync(outputFile, amdclean.clean({
        'filePath': outputFile
      }));
    }
  });

  done()
});

gulp.task('default', ['karma']);
