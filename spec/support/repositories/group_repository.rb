require_relative '../entities/group'

class GroupRepository
  include Datamappify::Repository

  for_entity Group
end
