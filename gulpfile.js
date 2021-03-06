var gulp = require('gulp-build-tasks')(require('gulp'))
var fs = require('fs')
var merge = require('merge').recursive
var mustache = require('mustache')
var path = require('path')
var plugin = require('gulp-load-plugins')()

var $ = gulp.bt.config
var npmconf = JSON.parse(fs.readFileSync(path.join(process.cwd(), 'package.json')))
var context = merge(true, npmconf, $)

gulp.bt.build({
  changelog: {
    src: () => plugin.downloadStream($.plexpy.changelog)
      .pipe(plugin.buffer())
      .pipe(plugin.replace('##', ''))
      .pipe(plugin.rename('changelog.txt'))
      .pipe(gulp.dest('dist/CONTROL'))
  },
  description: {
    src: () => plugin.downloadStream($.plexpy.readme)
      .pipe(plugin.buffer())
      .pipe(plugin.intercept(file => {
        var regex = /## Features\s*\*(.*\.\n)+/gm
        var matches = regex.exec(file.contents.toString())
        file.contents = new Buffer(matches[0].trim())
        return file
      }))
      .pipe(plugin.rename('description.txt'))
      .pipe(gulp.dest('dist/CONTROL'))
  },
  json: {
    build: src => src
      .pipe(plugin.mustache(context))
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.json']
  },
  png: {
    build: src => src
      .pipe(plugin.imagemin())
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.png']
  },
  sh: {
    build: src => src
      .pipe(plugin.mustache(context))
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.sh']
  },
  txt: {
    build: src => src
      .pipe(plugin.mustache(context))
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.txt']
  }
})

gulp.bt.reload('build').when({
  'src/**/*.json': ['build:json'],
  'src/**/*.png': ['build:png'],
  'src/**/*.sh': ['build:sh'],
  'src/**/*.txt': ['build:txt']
})

gulp.task('clean', () => {
  return gulp.src(['dist', '**/*.apk'])
    .pipe(plugin.debug({ title: 'clean:' }))
    .pipe(plugin.clean())
})

gulp.task('default', ['build'])
gulp.task('package', ['build'], plugin.shell.task(['echo -e "\n" | sudo -S python tools/apkg-tools.py create dist']))
