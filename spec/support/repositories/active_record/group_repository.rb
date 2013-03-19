class GroupRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Group
  default_provider :ActiveRecord
end
