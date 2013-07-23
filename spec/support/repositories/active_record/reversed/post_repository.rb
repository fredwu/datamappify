module Reversed
  class PostRepositoryActiveRecord
    include Datamappify::Repository

    for_entity Post
    default_provider :ActiveRecord

    group :provider => :ActiveRecord, :via => :author_id do
      map_attribute :author_name, :to => 'Reversed::Author#name'
      map_attribute :author_bio,  :to => 'Reversed::Author#bio'
    end
  end
end
