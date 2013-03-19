class RoleRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Role
  default_provider :ActiveRecord
end
