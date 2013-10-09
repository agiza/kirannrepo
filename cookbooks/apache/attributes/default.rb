default[:altisource][:altitomcat][:secure_proxy] = false
default[:apache][:workers][:port] = node[:altisource][:altitomcat][:secure_proxy] ? 8000 : 8080