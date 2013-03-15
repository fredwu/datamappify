module Datamappify
  module Repository
    module Persistence
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

      private

      def create_data_record(save_method_name, entity)
        data_object = data_class.new(entity.attributes)
        data_object.send(save_method_name) && data_object.entity
      end

      def update_data_record(save_method_name, entity)
        data_object = data_class.find(entity.id)
        data_object.update_attributes(entity.attributes)
        data_object.send(save_method_name) && data_object.entity
      end
    end
  end
end
