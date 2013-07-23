class UserRepositorySequel
  include Datamappify::Repository

  for_entity User
  default_provider :Sequel

  map_attribute :last_name,      :to => 'User#surname'
  map_attribute :driver_license, :to => 'UserDriverLicense#number'
  map_attribute :passport,       :to => 'UserPassport#number'
  map_attribute :health_care,    :to => 'UserHealthCare#number'
end
