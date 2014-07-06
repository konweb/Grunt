module.exports = function(grunt) {
  // package.jsonを読み込み
  var pkg = grunt.file.readJSON('package.json');

  grunt.initConfig({
    //cssファイルのミニファイ
    cssmin: {
      compress: {
        files: {
          //base.cssとstyle.cssを結合して、余分な部分を削除しmin.cssを作成
          './css/min.css': ['css/reset.css', 'css/style.css']
        }
      }
    },

    compass: {
        dist: {
            options: {
                config: 'config.rb'
            }
        }
    },

    cmq: {
      options: {
        log: true
      },
      main: {
        files: {
          './css/': ['./css/style.css']
        }
      }
    },

    kss: {
        options: {
          includeType: 'scss',
          includePath: 'styleguide/css/html.scss',
          template: 'styleguide/template'
        },
        dist: {
            files: {
                // dest : src
                'styleguide': ['styleguide/css/']
            }
        },
    },

    watch: {
      //scssファイルに変更があった場合
      sass: {
        files: ['scss/*.scss'], // ウォッチ対象として、ディレクトリ配下の*.scssを指定
        tasks: ['compass','cmq'],
      },
      //cssファイルに変更があった場合
      css: {
        files: ['css/style.css'], // ウォッチ対象として、ディレクトリ配下の*.cssを指定
        tasks: ['cssmin'],
      }
    }
  });

  // プラグインの読み込み
  var taskName;
  for(taskName in pkg.devDependencies) {
    if(taskName.substring(0, 6) == 'grunt-') {
      grunt.loadNpmTasks(taskName);
    }
  }

   // タスクの登録
  grunt.registerTask("default", ['watch']);
};