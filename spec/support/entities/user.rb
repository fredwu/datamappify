require_relative 'user_info'

class User
  include Datamappify::Entity

  attribute :first_name,     String
  attribute :last_name,      String
  attribute :age,            Integer
  attribute :passport,       String
  attribute :driver_license, String
  attribute :health_care,    String

  validates :first_name,     :presence => true,
                             :length   => { :minimum => 2 }
  validates :first_name,     :length   => { :minimum => 3 },
                             :on       => :update
  validates :driver_license, :presence => true,
                             :length   => { :minimum => 8 }

  attributes_from UserInfo, :prefix_with => :personal
  attributes_from UserInfo, :prefix_with => :business

  def full_name
    "#{first_name} #{last_name}"
  end
end
