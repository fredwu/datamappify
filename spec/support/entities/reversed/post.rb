require_relative 'author'

class Reversed::Post
  include Datamappify::Entity

  attribute :title, String

  attributes_from Reversed::Author, :prefix_with => :author
end
