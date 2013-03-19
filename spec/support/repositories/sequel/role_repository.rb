class RoleRepositorySequel
  include Datamappify::Repository

  for_entity Role
  default_provider :Sequel
end
