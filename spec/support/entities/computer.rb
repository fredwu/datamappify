require_relative 'computer_component/hardware'
require_relative 'computer_component/software'

class Computer
  include Datamappify::Entity

  attribute :brand, String

  attributes_from ComputerComponent::Hardware
  attributes_from ComputerComponent::Software, :prefix_with => :software
  attributes_from ComputerComponent::Software, :prefix_with => :game

  validates :brand, :presence => true
end
