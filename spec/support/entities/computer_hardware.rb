class ComputerHardware
  include Datamappify::Entity

  attribute :cpu, String
  attribute :ram, Integer, :default => 8192
  attribute :hdd, Integer, :default => 65536
  attribute :gfx, String
  attribute :vendor, String

  validates :ram, :hdd, :numericality => { :greater_than_or_equal_to => 4096 }
  validates :hdd,       :numericality => { :less_than_or_equal_to => 65536 }
end
