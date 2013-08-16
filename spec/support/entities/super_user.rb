require_relative 'user'

class SuperUser
  include Datamappify::Entity

  attributes_from User

  belongs_to :group
end
