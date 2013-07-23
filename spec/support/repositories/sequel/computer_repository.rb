class ComputerRepositorySequel
  include Datamappify::Repository

  for_entity Computer
  default_provider :Sequel

  map_attribute :cpu,             :to => 'ComputerComponent::Hardware#cpu'
  map_attribute :ram,             :to => 'ComputerComponent::Hardware#ram'
  map_attribute :hdd,             :to => 'ComputerComponent::Hardware#hdd'
  map_attribute :gfx,             :to => 'ComputerComponent::Hardware#gfx'
  map_attribute :vendor,          :to => 'ComputerComponent::Hardware#vendor'
  map_attribute :software_os,     :to => 'ComputerComponent::Software#os'
  map_attribute :software_vendor, :to => 'ComputerComponent::Software#vendor'
  map_attribute :game_os,         :to => 'ComputerComponent::Software#os',     :via => :game_id
  map_attribute :game_vendor,     :to => 'ComputerComponent::Software#vendor', :via => :game_id
end
