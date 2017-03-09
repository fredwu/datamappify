module Datamappify
  Config = Struct.new(:default_provider, :automap)

  # A Struct containing default configuration values
  #
  # @return [Config]
  def self.defaults
    @defaults ||= Config.new(nil, true)
  end

  # @yield
  #   configuration block
  #
  # @return [void]
  def self.config(&block)
    block.call(defaults)
  end
end
