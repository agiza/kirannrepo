#
# Cookbook Name: shibboleth_sp
# Attributes:: default
#

default["shibboleth_sp"]["entityid_domain"] = "altidev.net"
default["shibboleth_sp"]["entityid"] = 'https://rfint-iam-web-1.atltidev.net/shibboleth'
default["shibboleth_sp"]["idp_entityid"] = "https://rfint-iam-app-1.altidev.net/idp/shibboleth"
default["shibboleth_sp"]["remote_metadata"] = [] 
default["shibboleth_sp"]["local_metadata"] = []
default["shibboleth_sp"]["protected_paths"] = ["/iam/","/iamsvc/"]
default["shibboleth_sp"]["optional_paths"] = []
default["shibboleth_sp"]["cert_file"] = ''
default["shibboleth_sp"]["key_file"] = ''
default["shibboleth_sp"]["user"] = 'shibd'
default["shibboleth_sp"]["local_attribute_map"] = 'true' 
default["shibboleth_sp"]["remote_user_attributes"] = "uid"
