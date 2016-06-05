var gulp = require('gulp-build-tasks')(require('gulp'))
var fs = require('fs')
var path = require('path')
var plugin = require('gulp-load-plugins')()

var $ = gulp.bt.config
var npmconf = JSON.parse(fs.readFileSync(path.join(process.cwd(), 'package.json')))

gulp.bt.build({
  json: {
    build: src => src
      .pipe(plugin.mustache(npmconf))
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.json'],
    tasks: ['download']
  },
  png: {
    build: src => src
      .pipe(plugin.imagemin())
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.png'],
    tasks: ['download']
  },
  sh: {
    build: src => src
      .pipe(plugin.mustache(npmconf))
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.sh']
  },
  txt: {
    build: src => src
      .pipe(plugin.mustache(npmconf))
      .pipe(gulp.dest('dist')),
    src: ['src/**/*.txt'],
    tasks: ['download']
  }
})

gulp.bt.reload('build').when({
  'src/**/*.json': ['build:json'],
  'src/**/*.txt': ['build:txt']
})

gulp.task('clean', () => {
  return gulp.src(['dist', '**/*.apk'])
    .pipe(plugin.shell('rm -rf <%= (file.path) %>'))
})

gulp.task('default', ['build'])

gulp.task('package', ['build'], plugin.shell.task(['echo -e "\n" | sudo -S python tools/apkg-tools.py create dist']))

gulp.task('download', ['plexpy'])
gulp.task('plexpy', done => {
  var git = (method, value, args, next) => {
    if (value instanceof Array) {
      return plugin.git[method](value[0], value[1], args, (error) => {
        if (error) throw error
        return next()
      })
    }
    return plugin.git[method](value, args, (error) => {
      if (error) throw error
      return next()
    })
  }

  fs.stat(path.join(process.cwd(), 'dist/opt/plexpy'), (err, stats) => {
    if (!stats || !stats.isDirectory()) {
      return git('clone', $.plexpy.url, { args: 'dist/opt/plexpy --recursive' }, done)
    }
    return git('pull', ['origin', 'master'], { cwd: 'dist/opt/plexpy' }, done)
  })
})
gulp.task('plexpy:clean', () => {
  return gulp.src('dist/opt/plexpy')
    .pipe(plugin.clean())
})
