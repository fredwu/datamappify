require_relative 'user_repository'

class SuperUserRepositoryActiveRecord
  include Datamappify::Repository

  for_entity SuperUser
  default_provider :ActiveRecord

  group :via => :base_user_id do
    map_attribute :first_name, :to => 'User#first_name'
    map_attribute :last_name,  :to => 'User#surname'
    map_attribute :age,        :to => 'User#age'
  end

  group :reference_key => :user_id do
    map_attribute :driver_license, :to => 'UserDriverLicense#number'
    map_attribute :passport,       :to => 'UserPassport#number'
    map_attribute :health_care,    :to => 'UserHealthCare#number'
  end

  map_attribute :personal_info, :to => 'UserInfo#info', :via => :personal_info_id
  map_attribute :business_info, :to => 'UserInfo#info', :via => :business_info_id
end
