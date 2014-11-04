[Chef::Recipe, Chef::Resource].each { |l| l.send :include, ::Extensions }

es_nodes = search_for_nodes(node['realsearch']['app_search_es'])
rq_nodes = search_for_nodes(node['realsearch']['app_search_rq'])

Chef::Log.info("Found elasticsearch nodes at #{es_nodes.join(', ').inspect}")
Chef::Log.info("Found rabbit nodes at #{rq_nodes.join(', ').inspect}")

node.set['realsearch']['elasticsearch']['server']['host'] = es_nodes.fetch(0)

if node['realsearch']['ha_installation']
  rq_nodes = search_for_nodes(node['realsearch']['app_search_rq_ha'])
else
  rq_nodes = search_for_nodes(node['realsearch']['app_search_rq'])
end

node.set['realsearch']['indexservice']['amqp']['host'] = rq_nodes.fetch(0)
