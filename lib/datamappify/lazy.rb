require 'datamappify/lazy/source_attributes_walker'
require 'datamappify/lazy/source_attributes_walker'
require 'datamappify/lazy/attributes_handler'

module Datamappify
  module Lazy
    def self.included(klass)
      klass.class_eval do
        # @return [Repository]
        cattr_accessor :repository

        # @return [Hash]
        attr_accessor :cached_attributes
      end
    end

    def initialize(*args)
      super

      @cached_attributes  = {}
      @attributes_handler = AttributesHandler.new(self)
    end
  end
end
