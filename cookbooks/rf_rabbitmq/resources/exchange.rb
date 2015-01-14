actions :add

attribute :exchange, :kind_of => String, :name_attribute => true
attribute :type, :kind_of => String
attribute :vhost, :kind_of => String
attribute :user, :kind_of => String
attribute :password, :kind_of => String

def initialize(*args)
  super
  @action = :add
end