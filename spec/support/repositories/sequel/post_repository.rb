class PostRepositorySequel
  include Datamappify::Repository

  for_entity Post
  default_provider :Sequel

  map_attribute :author_name, :to => 'Author#name', :via => :author_id
  map_attribute :author_bio,  :to => 'Author#bio'
end
