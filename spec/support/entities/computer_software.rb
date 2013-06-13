class ComputerSoftware
  include Datamappify::Entity

  attribute :os, String
  attribute :vendor, String

  references :osx
  references :windows
  references :linux

  validates_presence_of :os
end
