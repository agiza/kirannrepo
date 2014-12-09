rf-iam-liquibase Cookbook
=========================
Wrapper Cookbook for liquibase-cookbook-master for inserting IAM tables and seed data 


Requirements
------------

#### cookbooks
- `liquibase-cookbook-master` - community cookbook for installing liquibase
- `java` - Requires Java v 1.6 or above

#### packages
- `mysql-connector-java` - MySQL database driver jar


Attributes
#### rf-iam-liquibase::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['change_log_file']</tt></td>
    <td>String</td>
    <td>liquibase change log file location on disk </td>
    <td><tt></tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['driver']</tt></td>
    <td>String</td>
    <td>Database driver </td>
    <td><tt>com.mysql.jdbc.Driver</tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['adapter']</tt></td>
    <td>String</td>
    <td>Database Adapter </td>
    <td><tt>mysql</tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['host']</tt></td>
    <td>String</td>
    <td>Database hostname </td>
    <td><tt>node['ipaddress']</tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['port']</tt></td>
    <td>String</td>
    <td>Database port number </td>
    <td><tt>node['rf_iam_mysql']['port']</tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['database']</tt></td>
    <td>String</td>
    <td>Database Name </td>
    <td><tt>node['rf_iam_mysql']['dbname']</tt></tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['username']</tt></td>
    <td>String</td>
    <td>Database UserName </td>
    <td><tt>root</tt></td>
  </tr>
  <tr>
    <td><tt>['rf_iam_liquibase']['connection']['password']</tt></td>
    <td>String</td>
    <td>Database Password </td>
    <td><tt>node['rf_iam_mysql']['dbuser_root_pwd']</tt></td>
  </tr>
    
</table>


Usage
-----
#### rf-iam-liquibase::default

Include `rf-iam-liquibase` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rf-iam-liquibase]"
  ]
}
```

Contributing
------------
Altisource Labs

License and Authors
-------------------
Altisource Labs
