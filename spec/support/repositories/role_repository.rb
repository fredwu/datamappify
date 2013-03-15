require_relative '../entities/role'

class RoleRepository
  include Datamappify::Repository

  for_entity Role
end
