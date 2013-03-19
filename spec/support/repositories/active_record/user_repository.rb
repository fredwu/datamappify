class UserRepositoryActiveRecord
  include Datamappify::Repository

  for_entity User
  default_provider :ActiveRecord

  map_attribute :last_name,      'ActiveRecord::User#surname'
  map_attribute :driver_license, 'ActiveRecord::UserDriverLicense#number'
  map_attribute :passport,       'ActiveRecord::UserPassport#number'
  map_attribute :health_care,    'ActiveRecord::UserHealthCare#number'
end
