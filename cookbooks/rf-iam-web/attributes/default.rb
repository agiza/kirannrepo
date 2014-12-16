# required by rf-apache-shib-sp

default['rf_idp_metadata'] = "/etc/shibboleth/idp-metadata.xml"
default['rf_idp_metadatadir'] = "/etc/shibboleth"
default['rf_iam_sp_key'] = "/etc/shibboleth/sp-key.pem"
default['rf_iam_sp_cert'] = "/etc/shibboleth/sp-cert.pem"

# required by rf-shib-sp-metagen

default['sp_public_hostname'] = ""
default['sp_app_name']="iam"

