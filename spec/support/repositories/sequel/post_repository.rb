class PostRepositorySequel
  include Datamappify::Repository

  for_entity Post
  default_provider :Sequel

  group :provider => :Sequel, :via => :author_id do
    map_attribute :author_name, :to => 'Author#name'
    map_attribute :author_bio,  :to => 'Author#bio'
  end
end
