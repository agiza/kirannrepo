rf-shib-sp-metagen Cookbook
===================
Generates Shibboleth SP metadata and the key/cert pair. The sp-metadata.xml should be submitted to the idp admin. The key/cert pair
should be used to overwrite the pair generated during SP installation.

Related Cookbooks: rf-apache-shib-sp

Attributes
----------
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rf-shib-sp-metagen']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
rf-shib-sp-metagen::default

License and Authors
-------------------
Authors: Brandon Chen, Sean McNally
