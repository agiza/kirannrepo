default[:rvm][:default_ruby] = "ruby-1.9.3"
default[:rvm][:user_default_ruby] = "ruby-1.9.3"
default[:rvm][:global_gems] = [
	{ name: 'bundler', version: '1.3.5' },
	{ name: 'rake' , version: '10.1.0'},
	{ name: 'chef' , version: '11.4.4'}
]