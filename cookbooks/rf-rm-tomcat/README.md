rf-rm-tomcat Cookbook
=====================
This cookbook will create the RMS Application Server (TOMCAT) and install all the RMS applications

Requirements
------------
This cookbook depends:
1- Three templates included in the templates/default directory
	rf-rules-mgmt.properties.erb - this is the main properties file used by all the RMS applications
	server.xml.erb - this file will replace the standard server.xml file shipped with the Tomcat installation - this is necessary to provide larger packetsize
	setenv.sh.erb - create new environment variables used by TOMCAT - this environment will fine tune the JAVA VM for more memory
2- DEV-OPS supported "tomcat" cookbook
3- RPM's necessary to install the RMS applications:
	rules-mgmt-intrestwar - application provider for RMS REST services for application integration
	rules-mgmt-restwar - application provider of REST services used for applications that will create User Interfaces related to RMS (this application will require IAM to work)
	rules-mgmt-uiwar - User interface application for RMS - This applications will reuse the rules-mgmt-restwar service endpoint.
4- Most of the attributes used to configure the RMS application should have been created in the environment
	The attributes defined in the cookbook should be used only when creating local machines.


Attributes
----------
e.g.
#### rf-rm-tomcat::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['mongo']['database']</tt></td>
    <td>String</td>
    <td>Name of the database where one will find all the RMS collections</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['shibboleth']['host']</tt></td>
    <td>String</td>
    <td>Machine name for the IAM Shibboleth server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['iam']['host']</tt></td>
    <td>String</td>
    <td>Machine name for the IAM server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['mongo']['database']</tt></td>
    <td>String</td>
    <td>Name of the database where one will find all the RMS collections - The application expects to be working with a database named = realservicing-runtime</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['mongo']['replicaset']</tt></td>
    <td>String</td>
    <td>List of the mongoDB machines that will part of the replica set - include the names of the servers separated by comma</td>
    <td><tt>true</tt></td>
  </tr> 
  <tr>
    <td><tt>['rf']['rm']['rabbit']['host']</tt></td>
    <td>String</td>
    <td>Name of the Rabbit Servers used for notifications</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['rabbit']['port']</tt></td>
    <td>String</td>
    <td>Port used to connect to the MQ application on the Rabbit server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['rabbit']['username']</tt></td>
    <td>String</td>
    <td>Username used to connect to the MQ application on the Rabbit server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['rabbit']['password']</tt></td>
    <td>String</td>
    <td>Password used to connect to the MQ application on the Rabbit server</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>['rf']['rm']['rabbit']['virtualHost']</tt></td>
    <td>String</td>
    <td>Virtual Host configured used to connect to the MQ application on the Rabbit server - Virtual server for RMS</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### rf-rm-tomcat::default

e.g.
Just include `rf-rm-tomcat` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[rf-rm-tomcat]"
  ]
}
```
