'use strict'
module.exports = Builder

const child_process = require('child_process')
const fs = require('fs')
const log = require('bestikk-log')
const bfs = require('bestikk-fs')
const Uglify = require('bestikk-uglify')
const Download = require('bestikk-download')
const download = new Download({})
const OpalBuilder = require('opal-compiler').Builder

let stdout

String.prototype.endsWith = function (suffix) {
  return this.indexOf(suffix, this.length - suffix.length) !== -1
}

function Builder () {
  if (process.env.PRAWN_VERSION) {
    this.rougeVersion = process.env.ROUGE_VERSION
  } else {
    this.rougeVersion = 'v3.14.0' // or 'master'
  }
}

Builder.prototype.build = async function () {
  if (process.env.SKIP_BUILD) {
    log.info('SKIP_BUILD environment variable is true, skipping "build" task')
    return
  }
  if (process.env.DRY_RUN) {
    log.debug('build')
    return
  }

  const builder = this
  const start = process.hrtime()

  builder.clean() // clean
  await builder.downloadDependencies('jneen', 'rouge', builder.rougeVersion) // download dependencies
  try {
    builder.compile() // compile
  } catch (e) {
    console.log('Unable to compile', e)
  }
  await builder.uglify() // uglify (optional)
  log.success(`Done in ${process.hrtime(start)[0]} s`)
}

Builder.prototype.clean = function () {
  if (process.env.SKIP_CLEAN) {
    log.info('SKIP_CLEAN environment variable is true, skipping "clean" task')
    return
  }
  log.task('clean')
  this.removeBuildDirSync() // remove build directory
}

Builder.prototype.downloadDependencies = async function (org, name, version) {
  log.task('download dependencies')

  const target = `build/${name}.tar.gz`
  if (fs.existsSync(target)) {
    log.info(`${target} file already exists, skipping "download" task`)
  } else {
    await download.getContentFromURL(`https://codeload.github.com/${org}/${name}/tar.gz/${version}`, target)
  }
  if (fs.existsSync(`build/${name}`)) {
    log.info(`build/${name} directory already exists, skipping "untar" task`)
  } else {
    await bfs.untar(target, name, 'build',)
  }
}

Builder.prototype.removeBuildDirSync = function () {
  log.debug('remove build directory')
  bfs.removeSync('build')
  bfs.mkdirsSync('build')
}

Builder.prototype.removeDistDirSync = function () {
  log.debug('remove dist directory')
  bfs.removeSync('dist')
}

Builder.prototype.execSync = function (command) {
  log.debug(command)
  if (!process.env.DRY_RUN) {
    stdout = child_process.execSync(command)
    process.stdout.write(stdout)
    return stdout
  }
}

Builder.prototype.uglify = async function () {
  // Preconditions
  // - MINIFY environment variable is defined
  if (!process.env.MINIFY) {
    log.info('MINIFY environment variable is not defined, skipping "minify" task')
    return
  }
  log.task('uglify')

  const source = 'build/rouge.js'
  const destination = 'build/rouge.min.js'
  log.transform('minify', source, destination)
  await new Uglify(['--jscomp_off=undefinedVars', '--warning_level=QUIET']).minify(source, destination)
}

Builder.prototype.compile = function () {

  bfs.mkdirsSync('build')

  log.task('compile core lib')

  const opalBuilder = OpalBuilder.create()
  opalBuilder.appendPaths('node_modules/opal-runtime/src')
  opalBuilder.appendPaths('node_modules/opal-compiler/src/stdlib')
  opalBuilder.appendPaths('lib/rouge')
  opalBuilder.appendPaths('lib')
  opalBuilder.appendPaths('build/rouge/lib')
  opalBuilder.appendPaths('build/rouge/lib/rouge')
  opalBuilder.setCompilerOptions({ dynamic_require_severity: 'ignore', requirable: true })
  const data = opalBuilder.build('rouge').toString()
  fs.writeFileSync('build/rouge-lib.js', data, 'utf8')
}
