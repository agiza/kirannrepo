Description
===========
This cookbook defines recipes that write host aliases (an `/etc/hosts` file)
based on nodes listed in an attribute.

Usage
=====
Recipe custom_hosts
Define a list of node names in the `node[:hosts_to_add]` attribute. Check the attributes (default) for an example

Recipe default
Searches for all the chef nodes in the same environment as the current node and add the aliases

License and Author
==================

Author:: Cosmin-Radu Vasii <cosmin.vasii@endava.com>
