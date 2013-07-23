module Reversed
  class AuthorRepositoryActiveRecord
    include Datamappify::Repository

    for_entity Author
    default_provider :ActiveRecord
  end
end
