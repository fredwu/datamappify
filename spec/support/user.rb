class User
  include Datamappify::Entity

  attribute :first_name, String
  attribute :last_name, String
  attribute :age, Integer

  validations do
    validates :first_name, :presence => true,
                           :length   => { :minimum => 2 }
  end

  relationships do
    has_one  :role
    has_many :comments
  end

  def full_name
    "#{first_name} #{last_name}"
  end
end
