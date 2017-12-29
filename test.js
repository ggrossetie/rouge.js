Opal = require('opal-runtime').Opal;

Opal.require('nodejs');

require('./build/rouge-lib.js');
Opal.require('rouge');

const source = "cat builder.rb";

const formatter = Opal.const_get_qualified(Opal.const_get_qualified(Opal.Rouge, 'Formatters'), 'HTML').$new();
const lexer = Opal.const_get_qualified(Opal.const_get_qualified(Opal.Rouge, 'Lexers'), 'Shell').$new();
console.log(formatter.$format(lexer.$lex(source)));
