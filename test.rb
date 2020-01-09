require 'rouge'

source = 'cat builder.rb'
Rouge::Lexer.enable_debug!
formatter = Rouge::Formatters::HTML.new
lexer = Rouge::Lexers::Shell.new({debug: true})
p formatter.format(lexer.lex(source))