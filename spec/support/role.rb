class Role
  include Datamappify::Entity

  attribute :name, String

  relationships do
    has_many :users
  end
end
