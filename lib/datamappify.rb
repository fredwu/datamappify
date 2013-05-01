require 'active_model'
require 'datamappify/version'

module Datamappify
  # @return [Pathname]
  def self.root
    Pathname.new("#{File.dirname(__FILE__)}/datamappify")
  end
end

require 'datamappify/entity'
require 'datamappify/data'
require 'datamappify/repository'
