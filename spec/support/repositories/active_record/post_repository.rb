class PostRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Post
  default_provider :ActiveRecord

  map_attribute :author_name, 'ActiveRecord::Author#name', :via => :author_id
  map_attribute :author_bio,  'ActiveRecord::Author#bio'
end
