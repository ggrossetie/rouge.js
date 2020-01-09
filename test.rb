require 'rouge'

# make some nice lexed html
source = 'cat builder.rb'
Rouge::Lexer.enable_debug!
formatter = Rouge::Formatters::HTML.new
lexer = Rouge::Lexers::Shell.new({debug: true})
formatter.format(lexer.lex(source))

stream = StringScanner.new('cat builder.rb')
if stream.skip(/cat/)
  puts stream[0].inspect
end