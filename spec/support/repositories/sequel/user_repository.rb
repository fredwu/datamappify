class UserRepositorySequel
  include Datamappify::Repository

  for_entity User
  default_provider :Sequel

  map_attribute :last_name,      'Sequel::User#surname'
  map_attribute :driver_license, 'Sequel::UserDriverLicense#number'
  map_attribute :passport,       'Sequel::UserPassport#number'
  map_attribute :health_care,    'Sequel::UserHealthCare#number'
end
