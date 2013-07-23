class ComputerSoftware < ActiveRecord::Base
  self.table_name = 'computer_component_softwares'
end

class ComputerRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Computer
  default_provider :ActiveRecord

  map_attribute :cpu,             :to => 'ComputerComponent::Hardware#cpu'
  map_attribute :ram,             :to => 'ComputerComponent::Hardware#ram'
  map_attribute :hdd,             :to => 'ComputerComponent::Hardware#hdd'
  map_attribute :gfx,             :to => 'ComputerComponent::Hardware#gfx'
  map_attribute :vendor,          :to => 'ComputerComponent::Hardware#vendor'
  map_attribute :software_os,     :to => 'ComputerSoftware#os'
  map_attribute :software_vendor, :to => 'ComputerSoftware#vendor'
  map_attribute :game_os,         :to => 'ComputerSoftware#os',     :via => :game_id
  map_attribute :game_vendor,     :to => 'ComputerSoftware#vendor', :via => :game_id
end
