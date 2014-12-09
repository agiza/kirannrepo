rf-iam-web Cookbook
==========================

On IAM web node, run the two cookbooks in the order

1. rf-apache-shib-sp
2. rf-iam-web


Attributes
----------
TODO: List your cookbook attributes here.

e.g.
#### rf-apache-shib-sp::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rf-apache-shib-sp']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
rf-apache-shib-sp::default
rf-iam-web::default

License and Authors
-------------------
Authors: Brandon Chen
