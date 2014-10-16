if defined?(ChefSpec)
  def add_rf_rabbitmq_queue(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rf_rabbitmq_queue, :add, resource_name)
  end
  def add_rf_rabbitmq_binding(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rf_rabbitmq_binding, :add, resource_name)
  end
  def add_rf_rabbitmq_exchange(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rf_rabbitmq_exchange, :add, resource_name)
  end
end
