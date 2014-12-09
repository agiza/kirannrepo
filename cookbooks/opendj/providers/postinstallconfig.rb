action :run do
  directory "#{node['opendj']['home']}/certs" do
    owner "#{node['opendj']['user']}"
    mode "0755"
  end

  cookbook_file "#{node['opendj']['home']}/certs/#{node['opendj']['ssl_cert']}" do
    owner "#{node['opendj']['user']}"
    mode "0644"
  end
  cookbook_file "#{node['opendj']['home']}/certs/#{node['opendj']['ssl_key']}" do
    owner "#{node['opendj']['user']}"
    mode "0644"
  end

  cacerts = ""
  node['opendj']['ssl_chain'].each do |cert|
    cookbook_file "#{node['opendj']['home']}/certs/#{cert}" do
      owner "#{node['opendj']['user']}"
      mode "0644"
    end
    cacerts = cacerts + "#{cert} "
  end

  script "create_keystore" do
    interpreter "bash"
    cwd "#{node['opendj']['home']}/certs"
    user "#{node['opendj']['user']}"
    code <<-EOH
      cat #{cacerts} > cacerts.crt
      openssl pkcs12 -export \
        -in #{node['opendj']['ssl_cert']} \
        -inkey #{node['opendj']['ssl_key']} \
        -out Mycertificate.pfx \
        -password pass:#{node['opendj']['keystore_pass']} \
        # -chain \
        # -CAfile cacerts.crt
    EOH
  end

  script "install_opendj" do
    interpreter "bash"
    cwd "#{node['opendj']['home']}"
    user "#{node['opendj']['user']}"
    code <<-EOH
      ./setup --cli \
        --no-prompt \
        --addBaseEntry \
        --enableStartTLS \
        --doNotStart \
        --acceptLicense \
        --noPropertiesFile \
        --usePkcs12Keystore #{node['opendj']['home']}/certs/Mycertificate.pfx \
        --keyStorePassword #{node["opendj"]["keystore_pass"]} \
        --baseDN #{node["opendj"]["user_root_dn"]} \
        --ldapPort #{node["opendj"]["standard_port"]} \
        --adminConnectorPort #{node["opendj"]["admin_port"]} \
        --rootUserDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
        --rootUserPassword "#{node["opendj"]["dir_manager_password"]}" \
        --ldapsPort #{node["opendj"]["ssl_port"]}
    EOH
  end

  script "create_init_script" do
    interpreter "bash"
    code <<-EOH
      #{node['opendj']['home']}/bin/create-rc-script \
       --outputFile /etc/init.d/opendj \
       --userName #{node['opendj']['user']}
    EOH
  end

  service "opendj" do
    action [ :start, :enable ]
  end

  template "#{node['opendj']['home']}//config/java.properties" do
    source "java.properties.erb"
    mode "0644"
  end

  script "reload_java_properties_file" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code "#{node['opendj']['home']}/bin/dsjavaproperties"
  end

  commonArguments = <<-EOH.strip
   --trustAll \
   --port #{node["opendj"]["ssl_port"]} \
   --hostname 127.0.0.1 \
   --bindDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
   --bindPassword #{node["opendj"]["dir_manager_password"]}
  EOH
  
  node["opendj"]["ldif_files"].each() do |ldif|
    cookbook_file "#{node['opendj']['home']}/ldif/#{ldif}" do
      mode "0644"
    end
    script "import_ldif_#{ldif}" do
      interpreter "bash"
      user "#{node['opendj']['user']}"
      code <<-EOH
        #{node["opendj"]["home"]}/bin/ldapmodify \
         #{commonArguments} \
         --continueOnError --useSSL --defaultAdd \
         --filename #{node['opendj']['home']}/ldif/#{ldif}
      EOH
    end
  end

  node["opendj"]["indexes"].each() do |index|
    indexargs = ""
    index["itypes"].each() do |itype|
      indexargs << "--set index-type:#{itype} "
    end
    index["attributes"].each() do |name,value|
      script "create_index_#{name}" do
        interpreter "bash"
        user "#{node['opendj']['user']}"
        code <<-EOH
          #{node["opendj"]["home"]}/bin/dsconfig create-local-db-index \
           #{commonArguments} \
           --no-prompt \
           --backend-name userRoot \
           --index-name #{name} \
           #{indexargs}
        EOH
      end
      if value != ""
        script "index_entry_limit_#{name}" do
          interpreter "bash"
          user "#{node['opendj']['user']}"
          code <<-EOH
            #{node["opendj"]["home"]}/bin/dsconfig set-local-db-index-prop \
             #{commonArguments} \
             --no-prompt \
             --backend-name userRoot \
             --index-name #{name} \
             --set index-entry-limit:#{value}
          EOH
        end
      end
    end
  end

  # Enable replication
  results = Chef::Search::Query.new.search(:node, node["opendj"]["replication"]["host_search"] + "AND chef_environment:#{node.chef_environment}").first.compact
  if not results.nil? and results.count > 0

    repargs = ""

    firstNode = results.fetch(0)
    firstHost = firstNode['ipaddress']
    repargs << " --host1 #{firstHost}"
    repargs << " --port1 #{node['opendj']['admin_port']}"
    repargs << " --bindDN1 \"#{node['opendj']['dir_manager_bind_dn']}\""
    repargs << " --bindPassword1 #{node['opendj']['dir_manager_password']}"
    repargs << " --replicationPort1 #{node['opendj']['replication']['port']}"

    currentHost = "#{node['ipaddress']}"
    repargs << " --host2 #{currentHost}"
    repargs << " --port2 #{node['opendj']['admin_port']}"
    repargs << " --bindDN2 \"#{node['opendj']['dir_manager_bind_dn']}\""
    repargs << " --bindPassword2 #{node['opendj']['dir_manager_password']}"
    repargs << " --replicationPort2 #{node['opendj']['replication']['port']}"

    script "replication_enable" do
      interpreter "bash"
      user "#{node['opendj']['user']}"
      code <<-EOH
      #{node["opendj"]["home"]}/bin/dsreplication enable \
        --adminUID #{node["opendj"]["replication"]["uid"]} \
        --adminPassword "#{node["opendj"]["replication"]["password"]}" \
        --baseDN #{node["opendj"]["user_root_dn"]} \\
        #{repargs} \
        --trustAll \
        --no-prompt
      EOH
    end
  end

  node["opendj"]["properties"].each() do |name,operations|
    propargs = ""
    if operations.has_key?('flags')
      operations['flags'].each() do |flag,value|
        propargs << "--#{flag} \"#{value}\" "
      end
    end
    if operations.has_key?('set')
      operations['set'].each() do |prop,value|
        propargs << "--set \"#{prop}:#{value}\" "
      end
    end
    if propargs == ""
      next
    end
    script "property_#{name}" do
      interpreter "bash"
      user "#{node['opendj']['user']}"
      code <<-EOH
        #{node['opendj']['home']}/bin/dsconfig set-#{name}-prop \
         #{commonArguments} \
         #{propargs} \
         --no-prompt
      EOH
    end
  end

  # Set password policy and password validator
  script "delete_character_set" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
    #{node['opendj']['home']}/bin/dsconfig delete-password-validator \
        --port  #{node["opendj"]["admin_port"]} \
        --hostname 127.0.0.1 \
        --bindDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
        --bindPassword "#{node["opendj"]["dir_manager_password"]}" \
        --validator-name "Character Set" \
        --trustAll \
        --no-prompt
    EOH
  end

  script "create_character_set" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
    #{node['opendj']['home']}/bin/dsconfig create-password-validator \
        --port  #{node["opendj"]["admin_port"]} \
        --hostname 127.0.0.1 \
        --bindDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
        --bindPassword "#{node["opendj"]["dir_manager_password"]}" \
        --validator-name "Character Set" \
        --set allow-unclassified-characters:true \
        --set enabled:true \
        --set character-set:1:0123456789 \
        --set character-set:1:ABCDEFGHIJKLMNOPQRSTUVWXYZ \
        --set character-set:1:abcdefghijklmnopqrstuvwxyz \
        --type character-set \
        --trustAll \
        --no-prompt
    EOH
  end

  script "delete_length_based_password_validator" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
    #{node['opendj']['home']}/bin/dsconfig delete-password-validator \
        --port  #{node["opendj"]["admin_port"]} \
        --hostname 127.0.0.1 \
        --bindDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
        --bindPassword "#{node["opendj"]["dir_manager_password"]}" \
        --validator-name "Length-Based Password Validator" \
        --trustAll \
        --no-prompt
    EOH
  end

  script "create_length_based_password_validator" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
    #{node['opendj']['home']}/bin/dsconfig create-password-validator \
        --port  #{node["opendj"]["admin_port"]} \
        --hostname 127.0.0.1 \
        --bindDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
        --bindPassword "#{node["opendj"]["dir_manager_password"]}" \
        --validator-name "Length-Based Password Validator" \
        --set enabled:true \
        --set max-password-length:40 \
        --set min-password-length:8 \
        --type length-based \
        --trustAll \
        --no-prompt
    EOH
  end

  script "password_policy" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
    #{node['opendj']['home']}/bin/dsconfig set-password-policy-prop \
        --port  #{node["opendj"]["admin_port"]} \
        --hostname 127.0.0.1 \
        --bindDN "#{node["opendj"]["dir_manager_bind_dn"]}" \
        --bindPassword "#{node["opendj"]["dir_manager_password"]}" \
        --policy-name "Default Password Policy" \
        --set expire-passwords-without-warning:true \
        --set grace-login-count:1 \
        --set lockout-duration:10m \
        --set lockout-failure-count:3 \
        --set max-password-age:118d \
        --set min-password-age:28d \
        --set password-validator:"Length-Based Password Validator" \
        --set password-validator:"Character Set" \
        --trustAll \
        --no-prompt
    EOH
  end

  # Stop the service so we can rebuild the indexes
  service "opendj_stop" do
    service_name "opendj"
    action :stop
    pattern "org.opends.server.core.DirectoryServer"
    supports :status => false
    # Work around http://tickets.opscode.com/browse/CHEF-2345
    provider Chef::Provider::Service::Init
  end

  script "rebuild_indexes" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
      #{node["opendj"]["home"]}/bin/rebuild-index \
       --rebuildAll \
       --baseDN #{node["opendj"]["user_root_dn"]}
    EOH
    # Start the server back up when we're done
    notifies :start, resources(:service => "opendj")
  end

  cookbook_file "#{node['opendj']['home']}/#{node['opendj']['backup_ldif']}" do
    owner "#{node['opendj']['user']}"
    mode "0644"
  end

  # Calling File.basename doesn't work here because of a naming conflict
  # with Chef::Provider::File:Class
  require 'pathname'
  pn = Pathname.new(node['opendj']['backup_ldif'])
  uncompressed = pn.basename(".gz").to_s
  if uncompressed != node['opendj']['backup_ldif']
    script "decompress_backup" do
      interpreter "bash"
      user "#{node['opendj']['user']}"
      code <<-EOH
        gunzip #{node['opendj']['home']}/#{node['opendj']['backup_ldif']}
      EOH
    end
  end
  script "import_backup" do
    interpreter "bash"
    user "#{node['opendj']['user']}"
    code <<-EOH
      #{node["opendj"]["home"]}/bin/import-ldif \
       --includeBranch #{node["opendj"]["user_root_dn"]} \
       --backendID userRoot \
       --ldifFile #{node['opendj']['home']}/#{uncompressed}
    EOH
    # Start the server back up when we're done
    notifies :start, resources(:service => "opendj")
  end
end
