class CommentRepositorySequel
  include Datamappify::Repository

  for_entity Comment
  default_provider :Sequel
end
