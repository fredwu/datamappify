module Reversed
  class AuthorRepositorySequel
    include Datamappify::Repository

    for_entity Author
    default_provider :Sequel
  end
end
