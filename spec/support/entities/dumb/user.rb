module Dumb
  class User
    include Datamappify::Entity

    attribute :first_name,     String
    attribute :last_name,      String
    attribute :health_care,    String
  end
end
