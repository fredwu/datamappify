class Post
  include Datamappify::Entity

  attribute :title,       String

  attributes_from Author, :prefix_with => :author
end
