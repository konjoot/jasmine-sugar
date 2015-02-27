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
gulp.task('karma', function (done) {
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


gulp.task('build', function() {
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
});

gulp.task('test', ['coffee', 'karma']);
