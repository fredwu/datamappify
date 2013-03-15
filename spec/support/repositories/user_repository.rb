class UserRepository
  include Datamappify::Repository

  for_entity User
end
