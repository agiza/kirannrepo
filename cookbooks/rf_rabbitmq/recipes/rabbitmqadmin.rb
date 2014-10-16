bash "download rabbitmqadmin" do
  cwd "/tmp"
  code <<-EOH
              wget http://guest:guest@localhost:15672/cli/rabbitmqadmin
              chmod +x rabbitmqadmin
              cp -f rabbitmqadmin /usr/local/bin/rabbitmqadmin
  EOH
end