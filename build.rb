require 'opal'

builder = Opal::Builder.new
builder.append_paths('lib')
builder.append_paths('lib/rouge')
builder.append_paths('build/rouge/lib')
builder.compiler_options = {'dynamic_require_severity': 'ignore'}
result = builder.build('rouge').to_s
File.write 'rouge-lib.js', builder.to_s
