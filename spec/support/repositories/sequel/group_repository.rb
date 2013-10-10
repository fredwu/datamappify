require_relative 'super_user_repository'

class GroupRepositorySequel
  include Datamappify::Repository

  for_entity Group
  default_provider :Sequel

  references :leader, :via => SuperUserRepositorySequel
  references :users,  :via => SuperUserRepositorySequel
end
