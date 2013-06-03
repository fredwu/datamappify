require_relative 'user_repository'

class AdminUserRepositorySequel < UserRepositorySequel
  for_entity AdminUser
end
