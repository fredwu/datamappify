class GroupRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Group
  default_provider :ActiveRecord

  references :users, :via => UserRepositoryActiveRecord
end
