Opal = require('opal-runtime').Opal

Opal.require('nodejs')

require('./build/rouge-lib.js')
Opal.require('rouge')

const source = 'cat builder.rb'['$force_encoding']('utf-8')

const formatter = Opal.const_get_qualified(Opal.const_get_qualified(Opal.Rouge, 'Formatters'), 'HTML').$new()
Opal.const_get_qualified(Opal.Rouge, 'Lexer')['$enable_debug!']()
const lexer = Opal.const_get_qualified(Opal.const_get_qualified(Opal.Rouge, 'Lexers'), 'Shell').$new(Opal.hash2(['debug'], { 'debug': true }))
console.log(formatter.$format(lexer.$lex(source)))