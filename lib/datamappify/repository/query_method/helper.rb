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
      end
    end
  end
end
