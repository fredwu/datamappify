class ComputerHardware
  include Datamappify::Entity

  attribute :cpu, String
  attribute :ram, Integer
  attribute :hdd, Integer
  attribute :gfx, String
end
