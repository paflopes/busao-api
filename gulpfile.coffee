gulp = require "gulp"
coffee = require "gulp-coffee"
gutil = require "gulp-util"
sourcemaps = require "gulp-sourcemaps"
coffeelint = require "gulp-coffeelint"
nodemon = require "gulp-nodemon"

gulp.task "coffee", () ->
  gulp.src "./src/**/*.coffee"
  .pipe sourcemaps.init(null)
  .pipe(coffee(bare: true)).on "error", gutil.log
  .pipe sourcemaps.write()
  .pipe gulp.dest("./build/")

gulp.task "lint", () ->
  gulp.src "./src/**/*.coffee"
  .pipe coffeelint()
  .pipe coffeelint.reporter()

gulp.task "build", ["coffee", "lint"], () ->

gulp.task "watch", ["coffee", "lint"], () ->
  gulp.watch "./src/**/*.coffee", ["coffee", "lint"]

gulp.task "start", ["build"], () ->
  nodemon
    script: "build/main.js"
    ext: "coffee"
    watch: "src"
    tasks: "build"