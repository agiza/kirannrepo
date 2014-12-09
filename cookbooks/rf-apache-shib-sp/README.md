rf-apache-shib-sp Cookbook
==========================

Install apache with https, shibboleth sp 

Installation sequence:
1. run this cookbook on web node, don't start shibd or httpd service
2. run rf-iam-app installation on app node
3. copy idp-metadata.xml from app node to web node
4. start shibd and httpd on web node
5. run wget sp-metadata.xml on app node 
6. start tomcat on app node 

Requirements
------------
TODO: List your cookbook requirements. Be sure to include any requirements this cookbook has on platforms, libraries, other cookbooks, packages, operating systems, etc.

e.g.
#### packages
- `toaster` - rf-apache-shib-sp needs toaster to brown your bagel.

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
#### rf-apache-shib-sp::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `rf-apache-shib-sp` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rf-apache-shib-sp]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors
