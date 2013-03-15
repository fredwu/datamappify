require 'singleton'
require 'datamappify/repository/persistence'
require 'datamappify/repository/dsl'

module Datamappify
  module Repository
    include Persistence

    def self.included(klass)
      klass.class_eval do
        mattr_accessor :entity_class

        include Singleton
        extend DSL
      end
    end

    def initialize
      unless data_class_is_defined?
        apply_validations_to_data_class
        apply_relationships_to_data_class
        add_entity_to_data_class
      end
    end

    def method_missing(symbol, *args)
      data_class.send symbol, *args
    end

    private

    def data_class_is_defined?
      Data.const_defined?(entity_class.name, false)
    end

    def apply_validations_to_data_class
      if entity_class.stored_validations
        data_class.class_eval(&entity_class.stored_validations)
      end
    end

    def apply_relationships_to_data_class
      if entity_class.stored_relationships
        data_class.class_eval(&entity_class.stored_relationships)
      end
    end

    def add_entity_to_data_class
      data_class.class_eval <<-CODE
        def entity
          #{entity_class.name}.new(attributes)
        end
      CODE
    end

    def data_class
      @data_class ||= begin
        if data_class_is_defined?
          Data.const_get(entity_class.name, false)
        else
          Data.const_set(entity_class.name, Class.new(Data::Base))
        end
      end
    end

    def extract_entity_id(entity_or_id)
      entity_or_id.is_a?(Integer) ? entity_or_id : entity_or_id.id
    end
  end
end
