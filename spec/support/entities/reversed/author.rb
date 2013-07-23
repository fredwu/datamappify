module Reversed
  class Author
    include Datamappify::Entity

    attribute :name, String
    attribute :bio,  String
  end
end
