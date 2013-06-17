require_relative 'computer_hardware'
require_relative 'computer_software'

class Computer
  include Datamappify::Entity

  attribute :brand, String

  attributes_from ComputerHardware
  attributes_from ComputerSoftware, :prefix_with => :software
  attributes_from ComputerSoftware, :prefix_with => :game

  validates :brand, :presence => true
end
