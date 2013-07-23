module Reversed
  class PostRepositorySequel
    include Datamappify::Repository

    for_entity Post
    default_provider :Sequel

    group :provider => :Sequel, :via => :author_id do
      map_attribute :author_name, :to => 'Reversed::Author#name'
      map_attribute :author_bio,  :to => 'Reversed::Author#bio'
    end
  end
end
