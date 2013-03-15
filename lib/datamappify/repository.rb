require 'singleton'
require 'datamappify/repository/persistence'
require 'datamappify/repository/dsl'
require 'datamappify/repository/attributes_mapper'

module Datamappify
  module Repository
    include Persistence

    def self.included(klass)
      klass.class_eval do
        mattr_accessor :entity_class
        mattr_accessor :custom_attributes_mapping
        mattr_accessor :data_mapping

        klass.custom_attributes_mapping = {}
        klass.data_mapping = {}

        include Singleton
        extend DSL
      end
    end

    def initialize
      AttributesMapper.new(self).build_data_classes
    end
  end
end
