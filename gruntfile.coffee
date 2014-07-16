module.exports = (grunt) ->
  # package.jsonを読み込み
  pkg = grunt.file.readJSON('package.json')

  grunt.initConfig
    # Directory Path
    dir:
      root: './'
      sass: 'sass'
      css: 'css'
      js: 'js'

    # Minify
    cssmin:
      options:
        noAdvanced: true
      compress:
        files:
          '<%= dir.css %>/min.css': '<%= dir.css %>/*.css'

    # Sass Compile
    sass:
      dist:
        options:
          style: 'expanded' #nested,compact,compressed,expandeds
        files:
          '<%= dir.css %>/style.css' : '<%= dir.sass %>/style.sass'

    # Compass Compile
    compass:
        dist:
          options:
            config: 'config.rb'

    # Mqpacker
    cmq:
      options:
        log: true
      main:
        files:
          '<%= dir.css %>/': ['<%= dir.css %>/*.css']

    # Vendor Prefix
    autoprefixer:
      options:
        browsers: [ "last 2 version","ie 8","ie 9" ]
      files:
        expand: true
        flatten: true
        src: "<%= dir.css %>/*.css"
        dest: "<%= dir.css %>/"

    # Copy
    copy:
      sass:
        cwd: '<%= dir.sass %>/'
        expand: true
        src: '*'
        dest: 'copy/<%= dir.sass %>/'
        filter: 'isFile'
      js:
        cwd: '<%= dir.js %>/'
        expand: true
        src: '*'
        dest: 'copy/<%= dir.js %>/'
        filter: 'isFile'

    # Clean
    clean:
      sass: "test/*"

    connect:
      server:
        options:
          port: 8080
          hostname: '*'
          livereload: 35729
          # keepalive: true
          base: '<%= dir.root %>'

    # Style Guide
    kss:
        options:
          includeType: 'scss'
          includePath: '<%= dir.sass %>/html.scss'
          template: 'styleguide/template'
        dist:
          files:
              # dest : src
              'styleguide': ['<%= dir.sass %>/']

    # Monitoring
    watch:
      options:
        livereload: true

      #sass
      sass:
        files: ['<%= dir.sass %>/*.sass']
        tasks: ['sass','autoprefixer','cmq']

      #css
      css:
        files: ['<%= dir.css %>/*.css','!<%= dir.css %>/min.css'] # ウォッチ対象として、ディレクトリ配下の*.cssを指定
        tasks: ['cssmin']

      html:
        files: ['<%= dir.root %>/**/*.html']

  # Package Load
  for taskName of pkg.devDependencies
    grunt.loadNpmTasks taskName  if taskName.substring(0, 6) is "grunt-"

  # Task Default
  grunt.registerTask "default", ['connect','watch']

  # Task StyleGuide
  grunt.registerTask "dev", ['kss']