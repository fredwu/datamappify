module ComputerComponent
  class Software
    include Datamappify::Entity

    attribute :os, String
    attribute :vendor, String

    validates_presence_of :os
  end
end
