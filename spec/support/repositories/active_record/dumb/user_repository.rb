module Dumb
  class UserRepositoryActiveRecord
    include Datamappify::Repository

    for_entity User
    default_provider :ActiveRecord

    automap false

    map_attribute :first_name,     :to => 'Dumb::User#first_name'
    map_attribute :last_name,      :to => 'Dumb::User#surname'
  end
end
