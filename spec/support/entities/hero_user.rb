class HeroUser
  include Datamappify::Entity
  include Datamappify::Lazy

  attribute :first_name, String
  attribute :last_name,  String
  attribute :nickname,   String
  attribute :gender,     String

  validates :first_name, :presence => true,
                         :length   => { :minimum => 2 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
