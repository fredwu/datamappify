module Datamappify
  class Repository
    def initialize(entity_class)
      @entity_class = entity_class

      unless data_class_is_defined?
        apply_validations_to_data_class
        apply_relationships_to_data_class
        add_entity_to_data_class
      end
    end

    def find(entity_or_id)
      data_class.find(extract_entity_id(entity_or_id))
    end

    [:save, :save!].each do |save_method_name|
      define_method save_method_name do |entity_or_collection|
        entity = collection = entity_or_collection

        if collection.is_a?(Array)
          collection.map { |e| send(save_method_name, e) }
        elsif entity.id
          update_data_record(save_method_name, entity)
        else
          create_data_record(save_method_name, entity)
        end
      end
    end

    [:destroy, :destroy!].each do |destroy_method_name|
      define_method destroy_method_name do |entity_or_id|
        data_class.send(destroy_method_name, extract_entity_id(entity_or_id))
      end
    end

    def create_data_record(save_method_name, entity)
      data_object = data_class.new(entity.attributes)
      data_object.send(save_method_name) && data_object.entity
    end

    def update_data_record(save_method_name, entity)
      data_object = data_class.find(entity.id)
      data_object.update_attributes(entity.attributes)
      data_object.send(save_method_name) && data_object.entity
    end

    def method_missing(symbol, *args)
      data_class.send symbol, *args
    end

    private

    def extract_entity_id(entity_or_id)
      entity_or_id.is_a?(Integer) ? entity_or_id : entity_or_id.id
    end

    def data_class_is_defined?
      Data.const_defined?(@entity_class.name, false)
    end

    def apply_validations_to_data_class
      if @entity_class.stored_validations
        data_class.class_eval(&@entity_class.stored_validations)
      end
    end

    def apply_relationships_to_data_class
      if @entity_class.stored_relationships
        data_class.class_eval(&@entity_class.stored_relationships)
      end
    end

    def add_entity_to_data_class
      data_class.class_eval <<-CODE
        def entity
          #{@entity_class.name}.new(attributes)
        end
      CODE
    end

    def data_class
      @data_class ||= begin
        if data_class_is_defined?
          Data.const_get(@entity_class.name, false)
        else
          Data.const_set(@entity_class.name, Class.new(Data::Base))
        end
      end
    end
  end
end
