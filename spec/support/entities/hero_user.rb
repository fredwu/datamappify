class HeroUser
  include Datamappify::Entity

  attribute :first_name, String
  attribute :last_name,  String
  attribute :nickname,   String

  def full_name
    "#{first_name} #{last_name}"
  end
end
