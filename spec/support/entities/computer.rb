require_relative 'computer_hardware'
require_relative 'computer_software'

class Computer
  include Datamappify::Entity

  attribute :brand, String

  attributes_from ComputerHardware
  attributes_from ComputerSoftware, :prefix_with => :software
end
