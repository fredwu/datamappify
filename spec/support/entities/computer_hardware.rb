class ComputerHardware
  include Datamappify::Entity

  attribute :cpu, String
  attribute :ram, Integer
  attribute :hdd, Integer
  attribute :gfx, String
  attribute :vendor, String

  validates :ram, :hdd, :numericality => { :greater_than_or_equal_to => 4096 }
  validates :hdd,       :numericality => { :less_than_or_equal_to => 65536 }
end
