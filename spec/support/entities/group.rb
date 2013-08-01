class Group
  include Datamappify::Entity

  attribute :name, String

  has_many :users, :via => User
end
