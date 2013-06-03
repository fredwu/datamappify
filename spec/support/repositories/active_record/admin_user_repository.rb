require_relative 'user_repository'

class AdminUserRepositoryActiveRecord < UserRepositoryActiveRecord
  for_entity AdminUser
end
