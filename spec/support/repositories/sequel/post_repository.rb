class PostRepositorySequel
  include Datamappify::Repository

  for_entity Post
  default_provider :Sequel

  map_attribute :author_name, 'Sequel::Author#name', :via => :author_id
  map_attribute :author_bio,  'Sequel::Author#bio'
end
