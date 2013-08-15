module Dumb
  class UserRepositorySequel
    include Datamappify::Repository

    for_entity User
    default_provider :Sequel

    automap false

    map_attribute :first_name,     :to => 'Dumb::User#first_name'
    map_attribute :last_name,      :to => 'Dumb::User#surname'
  end
end

