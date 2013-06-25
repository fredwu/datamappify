module Datamappify
  module Data
    module Criteria
      module Concerns
        module UpdatePrimaryRecord
          private

          def save(record)
            if options && options[:via] && options[:primary_record]
              update_primary_record_with(record)
            end

            record
          end

          def update_primary_record_with(record)
            save = self.class.superclass.new(options[:primary_record].class, entity, {
              :id => options[:primary_record].id
            })

            save.attributes_and_values = { options[:via] => record.id }
            save.send(:save_record)
          end
        end
      end
    end
  end
end
