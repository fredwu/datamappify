require_relative 'super_user_repository'

class GroupRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Group
  default_provider :ActiveRecord

  references :users, :via => SuperUserRepositoryActiveRecord
end
