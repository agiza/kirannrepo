rf-rm-mongodb Cookbook
======================
This cookbook will create the Mongo DB machines used by the RFNG RMS Service

Requirements
------------
This cookbook depends:
1- DEV-OPS Supported "mongodb" cookbook
2- realservicing-runtime.tar.gz - this is the bootstrap collections for the MongoDB 
	In case of upgrades that will require new collections we will have to 
	post a new version of this file and rerun the cookbook to update the MongoDB


Attributes
----------
e.g.
#### rf-rm-mongodb::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['mongodb']['config']['dbpath']</tt></td>
    <td>String</td>
    <td>Location in the file system where MongoDB will save the databases and collections</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### rf-rm-mongodb::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `rf-rm-mongodb` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rf-rm-mongodb]"
  ]
}
```
