# -*- coding: utf-8 -*- #
# frozen_string_literal: true

# stdlib
require 'pathname'

# The containing module for Rouge
module Rouge
  class << self
    def reload!
      Object.send :remove_const, :Rouge
      load __FILE__
    end

    # Highlight some text with a given lexer and formatter.
    #
    # @example
    #   Rouge.highlight('@foo = 1', 'ruby', 'html')
    #   Rouge.highlight('var foo = 1;', 'js', 'terminal256')
    #
    #   # streaming - chunks become available as they are lexed
    #   Rouge.highlight(large_string, 'ruby', 'html') do |chunk|
    #     $stdout.print chunk
    #   end
    def highlight(text, lexer, formatter, &b)
      lexer = Lexer.find(lexer) unless lexer.respond_to? :lex
      raise "unknown lexer #{lexer}" unless lexer

      formatter = Formatter.find(formatter) unless formatter.respond_to? :format
      raise "unknown formatter #{formatter}" unless formatter

      formatter.format(lexer.lex(text), &b)
    end
  end
end

require('rouge/version')
require('rouge/util')
require('rouge/text_analyzer')
require('rouge/token')

require('rouge/lexer')
require('rouge/regex_lexer')
require('rouge/template_lexer')

require('rouge/js')

# Explicit require
# REMIND: positive lookbehind (?<= ) are not supported by JavaScript's RegEx engine
require('rouge/lexers/abap')
# FIXME: SyntaxError: Invalid regular expression: /(?<=\n)(?=\s|/|<!--)/: Invalid group
require('rouge/lexers/actionscript')
# REMIND: Use YAML module
#require('rouge/lexers/apache')
# REMIND: Based on Markdown module
#require('rouge/lexers/apiblueprint')
# FIXME: RegexpError: too short escape sequence: /(-|\*|\+|&|≠|>=?|<=?|=|≥|≤|\/
require('rouge/lexers/apple_script')
# FIXME: SyntaxError: unknown regexp options: awk')
require('rouge/lexers/awk')
# FIXME: SyntaxError: unknown regexp options: bl
# REMIND: Based on XML module
#require('rouge/lexers/biml')
# REMIND: Invalid RegExp: Invalid group
#require('rouge/lexers/bsl')
# FIXME: SyntaxError: unknown regexp options: cyl
require('rouge/lexers/ceylon')
require('rouge/lexers/cfscript')
require('rouge/lexers/clojure')
require('rouge/lexers/cmake')
require('rouge/lexers/coffeescript')
require('rouge/lexers/common_lisp')
require('rouge/lexers/conf')
require('rouge/lexers/console')
require('rouge/lexers/coq')

require('rouge/lexers/c')
require('rouge/lexers/cpp')

require('rouge/lexers/csharp')
require('rouge/lexers/css')
require('rouge/lexers/dart')
require('rouge/lexers/diff')
# REMIND: Use YAML module
#require('rouge/lexers/digdag')
require('rouge/lexers/docker')
require('rouge/lexers/dot')
require('rouge/lexers/d')
require('rouge/lexers/eiffel')
require('rouge/lexers/elixir')
require('rouge/lexers/elm')
require('rouge/lexers/erb')
require('rouge/lexers/erlang')
require('rouge/lexers/factor')
require('rouge/lexers/fortran')
require('rouge/lexers/fsharp')
require('rouge/lexers/gherkin')
require('rouge/lexers/glsl')
require('rouge/lexers/go')

require('rouge/lexers/graphql')

require('rouge/lexers/groovy')
require('rouge/lexers/gradle')


require('rouge/lexers/haml')
require('rouge/lexers/handlebars')
require('rouge/lexers/haskell')
require('rouge/lexers/html')
require('rouge/lexers/http')
require('rouge/lexers/hylang')
require('rouge/lexers/idlang')
require('rouge/lexers/igorpro')
require('rouge/lexers/ini')
require('rouge/lexers/io')

require('rouge/lexers/java')
require('rouge/lexers/javascript')
require('rouge/lexers/jinja')

require('rouge/lexers/json')
require('rouge/lexers/json_doc')

require('rouge/lexers/jsonnet')
require('rouge/lexers/jsx')
require('rouge/lexers/julia')
require('rouge/lexers/kotlin')
# REMIND: Use YAML module
#require('rouge/lexers/lasso')
require('rouge/lexers/liquid')
require('rouge/lexers/literate_coffeescript')
require('rouge/lexers/literate_haskell')
require('rouge/lexers/llvm')
require('rouge/lexers/lua')
require('rouge/lexers/make')
#require('rouge/lexers/markdown')
require('rouge/lexers/matlab')
require('rouge/lexers/moonscript')
require('rouge/lexers/mosel')
# REMIND: Based on XML module
#require('rouge/lexers/mxml')
require('rouge/lexers/nasm')
require('rouge/lexers/nginx')
require('rouge/lexers/nim')
require('rouge/lexers/nix')
require('rouge/lexers/objective_c')
# OCamlCommon: uninitialized constant Rouge::Lexers::OCamlCommon
#require('rouge/lexers/ocaml')
require('rouge/lexers/pascal')
require('rouge/lexers/perl')

require('rouge/lexers/php')
require('rouge/lexers/hack')

require('rouge/lexers/plain_text')
require('rouge/lexers/plist')
require('rouge/lexers/pony')

require('rouge/lexers/praat')
require('rouge/lexers/prolog')
require('rouge/lexers/prometheus')
require('rouge/lexers/properties')
require('rouge/lexers/protobuf')
require('rouge/lexers/puppet')
require('rouge/lexers/python')
require('rouge/lexers/qml')
require('rouge/lexers/q')
require('rouge/lexers/racket')
require('rouge/lexers/r')

require('rouge/lexers/ruby')
require('rouge/lexers/irb')

require('rouge/lexers/rust')

require('rouge/lexers/sass/common')
require('rouge/lexers/sass')
require('rouge/lexers/scss')

# FIXME: SyntaxError: Invalid regular expression
#require('rouge/lexers/scala')
require('rouge/lexers/scheme')

require('rouge/lexers/sed')

require('rouge/lexers/shell')
require('rouge/lexers/powershell')

require('rouge/lexers/sieve')
require('rouge/lexers/slim')
require('rouge/lexers/smalltalk')
require('rouge/lexers/smarty')
require('rouge/lexers/sml')
require('rouge/lexers/sql')
require('rouge/lexers/swift')
require('rouge/lexers/tap')
require('rouge/lexers/tcl')
require('rouge/lexers/tex')
require('rouge/lexers/toml')

require('rouge/lexers/tulip')
require('rouge/lexers/turtle')
require('rouge/lexers/twig')

require('rouge/lexers/typescript/common')
require('rouge/lexers/typescript')
require('rouge/lexers/tsx')

require('rouge/lexers/vala')
require('rouge/lexers/vb')
require('rouge/lexers/verilog')
require('rouge/lexers/vhdl')
require('rouge/lexers/viml')
require('rouge/lexers/vue')
require('rouge/lexers/wollok')
# REMIND: Based on XML module
#require('rouge/lexers/xml')
# REMIND: Based on YAML module
#require('rouge/lexers/yaml')

require('rouge/guesser')
require('rouge/guessers/util')
require('rouge/guessers/glob_mapping')
require('rouge/guessers/modeline')
require('rouge/guessers/filename')
require('rouge/guessers/mimetype')
require('rouge/guessers/source')
require('rouge/guessers/disambiguation')

require('rouge/formatter')
require('rouge/formatters/html')
require('rouge/formatters/html_table')
require('rouge/formatters/html_pygments')
require('rouge/formatters/html_legacy')
require('rouge/formatters/html_linewise')
require('rouge/formatters/html_line_table')
require('rouge/formatters/html_inline')
require('rouge/formatters/terminal256')
require('rouge/formatters/tex')
require('rouge/formatters/null')

require('rouge/theme')
require('rouge/tex_theme_renderer')
require('rouge/themes/thankful_eyes')
require('rouge/themes/colorful')
require('rouge/themes/base16')
require('rouge/themes/github')
require('rouge/themes/igor_pro')
require('rouge/themes/monokai')
require('rouge/themes/molokai')
require('rouge/themes/monokai_sublime')
require('rouge/themes/gruvbox')
require('rouge/themes/tulip')
require('rouge/themes/pastie')
require('rouge/themes/bw')
require('rouge/themes/magritte')

Rouge::Lexer.enable_debug!