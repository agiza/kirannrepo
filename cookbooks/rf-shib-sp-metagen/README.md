rf-shib-sp-metagen Cookbook
===================
Generates Shibboleth SP metadata and the key/cert pair.

For example, in iqa (chef env) environment for realreport (app name), three files will be generated

/iam/share/iqa/realreport-metadata.xml
/iam/share/iqa/realreport/sp-cert.pem
/iam/share/iqa/realreport/sp-key.pem

The first file will be imported into IDP configuration manually (not needed for SP). The other two will be copied to overwrite the ones on all realreport SP servers.

Usage
-----
rf-shib-sp-metagen::default


License and Authors
-------------------
Authors: Brandon Chen
