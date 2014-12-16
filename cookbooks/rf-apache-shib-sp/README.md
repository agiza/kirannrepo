rf-apache-shib-sp Cookbook
==========================

This cookbook installs apache with https, shibboleth sp. You should also run additional recipe to install your ui content.
Use rf-iam-web as a reference

Related recipe: rf-shib-sp-metagen

Requirements
------------
Apache2.x with https
Shibboleth SP

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
    <td><tt>['rf-apache-shib-sp']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
rf-apache-shib-sp::default

License and Authors
-------------------
Authors: Brandon Chen, Sean McNally
