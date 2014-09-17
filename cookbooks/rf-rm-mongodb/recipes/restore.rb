#execute "Adjust Ownership" do
#  command 'chown -R mongo /data;chmod -R 744 /data'
#end

cookbook_file "/tmp/realservicing-runtime.tar.gz" do
     source "realservicing-runtime.tar.gz"
     mode 00775
end

execute "unzip realservicing-runtime" do 
   command 'cd /tmp;tar -xvf /tmp/realservicing-runtime.tar.gz'
end

mongoport = node[:mongodb][:config][:port]

execute "mongodbrestore" do 
   command "echo 'Restore instance with port: #{mongoport}';mongorestore --port #{mongoport} --db realservicing-runtime /tmp/realservicing-runtime"
end

