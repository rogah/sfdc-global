'use strict';

var gulp = require('gulp'),
  plugins = require('gulp-load-plugins')(),
  browserify = require('browserify'),
  source = require('vinyl-source-stream'),
  buffer = require('vinyl-buffer'),
  del = require('del'),
  path = require('path');

gulp.task('clean', function (done) {
  return del(['./resource-bundles/FinancingConnect.resource/dist'], {
    force: true
  }, done);
});

gulp.task('lint', ['clean'], function () {
  return gulp.src(['./gulpfile.js', './resource-bundles/FinancingConnect.resource/src/**/*.js'])
    .pipe(plugins.cached('lint'))
    .pipe(plugins.jshint())
    .pipe(plugins.jshint.reporter('jshint-stylish'))
    .pipe(plugins.jshint.reporter('fail'));
});

gulp.task('beautify:js', ['lint'], function () {
  return gulp.src(['./gulpfile.js', './resource-bundles/FinancingConnect.resource/src/**/*.js'], {
      base: './'
    })
    .pipe(plugins.jsbeautifier({
      config: '.jsbeautifyrc',
      mode: 'VERIFY_AND_WRITE'
    }))
    .pipe(gulp.dest('./'));
});

gulp.task('js', ['beautify:js'], function () {
  return browserify({
      entries: './resource-bundles/FinancingConnect.resource/src/app/app.js',
      debug: true
    }).bundle()
    .pipe(source('app.bundle.js'))
    .pipe(buffer())
    .pipe(plugins.sourcemaps.init({
      loadMaps: true
    }))
    .pipe(plugins.ngAnnotate())
    .pipe(plugins.uglify())
    .on('error', plugins.util.log)
    .pipe(plugins.sourcemaps.write('./maps'))
    .pipe(gulp.dest('./resource-bundles/FinancingConnect.resource/dist'));
});

gulp.task('css', ['clean'], function () {
  return gulp.src('./resource-bundles/FinancingConnect.resource/src/styles/app.less')
    .pipe(plugins.sourcemaps.init())
    .pipe(plugins.less({
      paths: [path.resolve('./resource-bundles/bower_components.resource/bootstrap/less')]
    }).on('error', plugins.util.log))
    .pipe(plugins.autoprefixer())
    .pipe(plugins.rename('app.bundle.css'))
    .pipe(plugins.minifyCss())
    .pipe(plugins.sourcemaps.write('./maps'))
    .pipe(gulp.dest('./resource-bundles/FinancingConnect.resource/dist'));
});

gulp.task('html', ['clean'], function () {
  return gulp.src('./resource-bundles/FinancingConnect.resource/src/app/**/*.html')
    .pipe(plugins.cached('minify:html'))
    .pipe(plugins.htmlmin({
      collapseWhitespace: true
    }))
    .pipe(gulp.dest('./resource-bundles/FinancingConnect.resource/dist'));
});

gulp.task('default', ['clean', 'lint', 'js', 'css', 'html']);
