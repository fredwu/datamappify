class ComputerSoftware < ActiveRecord::Base
  self.table_name = 'computer_component_softwares'
end

class ComputerRepositoryActiveRecord
  include Datamappify::Repository

  for_entity Computer
  default_provider :ActiveRecord

  map_attribute :cpu,             'ActiveRecord::ComputerComponent::Hardware#cpu'
  map_attribute :ram,             'ActiveRecord::ComputerComponent::Hardware#ram'
  map_attribute :hdd,             'ActiveRecord::ComputerComponent::Hardware#hdd'
  map_attribute :gfx,             'ActiveRecord::ComputerComponent::Hardware#gfx'
  map_attribute :vendor,          'ActiveRecord::ComputerComponent::Hardware#vendor'
  map_attribute :software_os,     'ActiveRecord::ComputerSoftware#os'
  map_attribute :software_vendor, 'ActiveRecord::ComputerSoftware#vendor'
  map_attribute :game_os,         'ActiveRecord::ComputerSoftware#os',     :via => :game_id
  map_attribute :game_vendor,     'ActiveRecord::ComputerSoftware#vendor', :via => :game_id
end
