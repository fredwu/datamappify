class Group
  include Datamappify::Entity

  attribute :name, String

  relationships do
    has_and_belongs_to_many :users
  end
end
