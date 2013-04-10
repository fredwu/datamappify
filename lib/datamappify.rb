require 'active_support'
require 'datamappify/version'

module Datamappify
  def self.root
    Pathname.new("#{File.dirname(__FILE__)}/datamappify")
  end
end

require 'datamappify/entity'
require 'datamappify/data'
require 'datamappify/repository'
