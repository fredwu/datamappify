class HeroUserRepository
  include Datamappify::Repository

  for_entity HeroUser
  default_provider :ActiveRecord

  map_attribute :first_name, 'ActiveRecord::HeroUser#first_name'
  map_attribute :last_name,  'Sequel::HeroUserLastName#last_name'
  map_attribute :gender,     'Sequel::HeroUserLastName#gender'
end
