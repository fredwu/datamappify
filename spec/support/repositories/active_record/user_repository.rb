class UserRepositoryActiveRecord
  include Datamappify::Repository

  for_entity User
  default_provider :ActiveRecord

  map_attribute :last_name,      :to => 'User#surname'
  map_attribute :driver_license, :to => 'UserDriverLicense#number'
  map_attribute :passport,       :to => 'UserPassport#number'
  map_attribute :health_care,    :to => 'UserHealthCare#number'
  map_attribute :personal_info,  :to => 'UserInfo#info', :via => :personal_info_id
  map_attribute :business_info,  :to => 'UserInfo#info', :via => :business_info_id
end
