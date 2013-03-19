class CommentRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Comment
  default_provider :ActiveRecord
end
