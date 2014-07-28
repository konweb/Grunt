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
      img: 'images'

    #Jade Compile
    jade:
      compile:
        options:
          pretty: true
          data:
            year: '<%= grunt.template.today("yyyy") %>'
        files:
          "index.html": "index.jade"

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
        src: "<%= dir.css %>/*.css"
        dest: "<%= dir.css %>/"
        flatten: true

    # Minify
    cssmin:
      options:
        noAdvanced: true
      files:
        src: "<%= dir.css %>/*.css"
        dest: "<%= dir.css %>/min.css"

    #Js Minify,Join
    uglify:
      min:
        expand: true
        src: "<%= dir.js %>/*.js"
        dest: "<%= dir.js %>/"
        ext: ".min.js"
        flatten: true
      join:
        src: ['<%= dir.js %>/*.js','!<%= dir.js %>/*.min.js']
        dest: '<%= dir.js %>/min.js'

    #Image Minify
    imagemin:
      static:
        # options:
        #   optimizationLevel: 7
        #   use: [mozjpeg()]

        files:
          '<%= dir.img %>/min/sample_min.png': '<%= dir.img %>/sample.png'

      all:
        files: [
          expand: true
          cwd: '<%= dir.img %>/'
          src: ['*.{png,jpg,gif}']
          dest: '<%= dir.img %>/min/'
        ]

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
      css: "<%= cssmin.files.dest %>"
      jsmin: "<%= dir.js %>/*.min.js"
      jsjoin: "<%= uglify.join.dest %>"

    #Server
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

      jade:
        files: ['<%= dir.root %>/**/*.jade']
        tasks: ['jade']

  # Package Load
  for taskName of pkg.devDependencies
    grunt.loadNpmTasks taskName  if taskName.substring(0, 6) is "grunt-"

  # Task Default
  grunt.registerTask "default", ['connect','watch']

  # Task cssmin
  grunt.registerTask "mincss", ['clean:css','cssmin']

  # Task Js Minify
  grunt.registerTask "jsmin", ['clean:jsmin','uglify:min']

  # Task Js Join
  grunt.registerTask "jsjoin", ['clean:jsjoin','uglify:join']

  # Task StyleGuide
  grunt.registerTask "dev", ['kss']
