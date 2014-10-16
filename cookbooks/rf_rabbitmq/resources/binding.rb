actions :add, :delete

attribute :exchange, :kind_of => String, :name_attribute => true
attribute :destination, :kind_of => String
attribute :routing_key, :kind_of => String, :default => ''
attribute :destination_type, :kind_of => String
attribute :vhost, :kind_of => String
attribute :user, :kind_of => String
attribute :password, :kind_of => String

def initialize(*args)
  super
  @action = :add
end