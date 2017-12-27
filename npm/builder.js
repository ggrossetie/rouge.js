'use strict';
module.exports = Builder;

const async = require('async');
const child_process = require('child_process');
const fs = require('fs');
const path = require('path');
const OpalCompiler = require('bestikk-opal-compiler');
const log = require('bestikk-log');
const bfs = require('bestikk-fs');
const download = require('bestikk-download');

let stdout;

String.prototype.endsWith = function (suffix) {
  return this.indexOf(suffix, this.length - suffix.length) !== -1;
};

function Builder () {
  if (process.env.PRAWN_VERSION) {
    this.rougeVersion = process.env.ROUGE_VERSION;
  } else {
    this.rougeVersion = 'v3.1.0'; // or 'master'
  }
}

Builder.prototype.build = function (callback) {
  if (process.env.SKIP_BUILD) {
    log.info('SKIP_BUILD environment variable is true, skipping "build" task');
    callback();
    return;
  }
  if (process.env.DRY_RUN) {
    log.debug('build');
    callback();
    return;
  }

  const builder = this;
  const start = process.hrtime();

  async.series([
    callback => builder.clean(callback), // clean
    callback => builder.downloadDependencies('jneen', 'rouge', builder.rougeVersion, callback), // download dependencies
    callback => builder.compile(callback), // compile
    callback => builder.uglify(callback) // uglify (optional)
  ], () => {
    log.success(`Done in ${process.hrtime(start)[0]} s`);
    typeof callback === 'function' && callback();
  });
};

Builder.prototype.clean = function (callback) {
  if (process.env.SKIP_CLEAN) {
    log.info('SKIP_CLEAN environment variable is true, skipping "clean" task');
    callback();
    return;
  }
  log.task('clean');
  this.removeBuildDirSync(); // remove build directory
  callback();
};

Builder.prototype.downloadDependencies = function (org, name, version, callback) {
  log.task('download dependencies');

  const builder = this;
  const target = `build/${name}.tar.gz`
  async.series([
    callback => {
      if (fs.existsSync(target)) {
        log.info(`${target} file already exists, skipping "download" task`);
        callback();
      } else {
        download.getContentFromURL(`https://codeload.github.com/${org}/${name}/tar.gz/${version}`, target, callback);
      }
    },
    callback => {
      if (fs.existsSync(`build/${name}`)) {
        log.info(`build/${name} directory already exists, skipping "untar" task`);
        callback();
      } else {
        bfs.untar(target, name, 'build', callback);
      }
    }
  ], () => typeof callback === 'function' && callback());
};

Builder.prototype.removeBuildDirSync = function () {
  log.debug('remove build directory');
  bfs.removeSync('build');
  bfs.mkdirsSync('build');
};

Builder.prototype.removeDistDirSync = function () {
  log.debug('remove dist directory');
  bfs.removeSync('dist');
};

Builder.prototype.execSync = function (command) {
  log.debug(command);
  if (!process.env.DRY_RUN) {
    stdout = child_process.execSync(command);
    process.stdout.write(stdout);
    return stdout;
  }
};

Builder.prototype.uglify = function (callback) {
  // Preconditions
  // - MINIFY environment variable is defined
  if (!process.env.MINIFY) {
    log.info('MINIFY environment variable is not defined, skipping "minify" task');
    callback();
    return;
  }
  const uglify = require('bestikk-uglify');
  log.task('uglify');

  const tasks = [
    {source: 'build/rouge.js', destination: 'build/rouge.min.js' }
  ].map(file => {
    const source = file.source;
    const destination = file.destination;
    log.transform('minify', source, destination);
    return callback => uglify.minify(source, destination, callback);
  });

  async.parallelLimit(tasks, 4, callback);
};

Builder.prototype.compile = function (callback) {

  bfs.mkdirsSync('build');

  log.task('compile core lib');
  new OpalCompiler({dynamicRequireLevel: 'ignore', defaultPaths: ['build/rouge/lib']})
    .compile('rouge', 'build/rouge-lib.js');

  callback();
};
