actions :add, :delete

attribute :name, :kind_of => String, :name_attribute => true
attribute :vhost, :kind_of => String
attribute :durability, :kind_of => String
attribute :autoDelete, :kind_of => String
attribute :user, :kind_of => String
attribute :password, :kind_of => String
attribute :arguments, :kind_of => String

def initialize(*args)
  super
  @action = :add
end