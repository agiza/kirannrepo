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
  
  def set_rabbitmq_parameter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_parameter, :set, resource_name)
  end

  def clear_rabbitmq_parameter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_parameter, :clear, resource_name)
  end

  def list_rabbitmq_parameter(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rabbitmq_parameter, :list, resource_name)
  end

end
