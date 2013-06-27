class ComputerRepositorySequel
  include Datamappify::Repository

  for_entity Computer
  default_provider :Sequel

  map_attribute :cpu,             'Sequel::ComputerComponent::Hardware#cpu'
  map_attribute :ram,             'Sequel::ComputerComponent::Hardware#ram'
  map_attribute :hdd,             'Sequel::ComputerComponent::Hardware#hdd'
  map_attribute :gfx,             'Sequel::ComputerComponent::Hardware#gfx'
  map_attribute :vendor,          'Sequel::ComputerComponent::Hardware#vendor'
  map_attribute :software_os,     'Sequel::ComputerComponent::Software#os'
  map_attribute :software_vendor, 'Sequel::ComputerComponent::Software#vendor'
  map_attribute :game_os,         'Sequel::ComputerComponent::Software#os',     :via => :game_id
  map_attribute :game_vendor,     'Sequel::ComputerComponent::Software#vendor', :via => :game_id
end
