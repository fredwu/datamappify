require_relative '../entities/user'

class UserRepository
  include Datamappify::Repository

  for_entity User

  map_attribute :gender,         'User#sex'
  map_attribute :passport,       'UserPassport#number'
  map_attribute :driver_license, 'UserDriverLicense#number'
end
