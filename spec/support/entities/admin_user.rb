require_relative 'user'

class AdminUser < User
  attribute :level, Integer
end
