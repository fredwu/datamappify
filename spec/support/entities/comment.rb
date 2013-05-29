class Comment
  include Datamappify::Entity

  attribute :content, String

  references :user
end
