require_relative 'super_user'

class Group
  include Datamappify::Entity

  attribute :name, String

  has_many :users, :via => SuperUser
end
