'use strict';

module.exports = function(grunt) {

  //Load NPM tasks
  grunt.loadNpmTasks('grunt-browserify');
  grunt.loadNpmTasks('grunt-contrib-watch');

  // Project Configuration
  grunt.initConfig({
    browserify: {
      client: {
        src: ['buffertools.js'],
        dest: 'bundle.js',
        options: {
          debug: true,
          standalone: 'buffertools',
        }
      }
    },
    watch: {
      scripts: {
        files: ['**/*.js', '**/*.html', '!**/node_modules/**', '!**/bundle.js'],
        tasks: ['browserify'],
      },
    },
  });

  grunt.registerTask('default', ['watch']);

};

