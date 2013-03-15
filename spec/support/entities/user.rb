class User
  include Datamappify::Entity

  attribute :first_name, String
  attribute :last_name,  String
  attribute :gender,     String
  attribute :age,        Integer
  attribute :passport,   String

  validates :first_name, :presence => true,
                         :length   => { :minimum => 2 }
  validates :passport,   :presence => true,
                         :length   => { :minimum => 8 }

  def full_name
    "#{first_name} #{last_name}"
  end
end
