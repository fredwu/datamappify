require_relative '../entities/comment'

class CommentRepository
  include Datamappify::Repository

  for_entity Comment
end
