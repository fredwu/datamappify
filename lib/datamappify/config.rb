module Datamappify
  Config = Struct.new(:default_provider)

  # A Struct containing default configuration values
  #
  # @return [Config]
  def self.defaults
    @defaults ||= Config.new
  end

  # @yield
  #   configuration block
  #
  # @return [void]
  def self.config(&block)
    block.call(defaults)
  end
end
