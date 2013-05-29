class ComputerSoftware
  include Datamappify::Entity

  attribute :os, String

  references :osx
  references :windows
  references :linux
end
