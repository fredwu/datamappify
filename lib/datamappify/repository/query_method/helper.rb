module Datamappify
  module Repository
    module QueryMethod
      module Helper
        private

        def attributes_walker(&block)
          Transaction.new(@mapper) do
            @mapper.classified_attributes.each do |provider_name, attributes|
              attributes.classify(&:source_class).each do |source_class, attrs|
                block.call(provider_name, source_class, attrs)
              end
            end
          end
        end

        def extract_entity_id(id_or_entity)
          id_or_entity.is_a?(Integer) ? id_or_entity : id_or_entity.id
        end
      end
    end
  end
end
