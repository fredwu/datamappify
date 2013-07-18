module Datamappify
  module Data
    module Criteria
      module Relational
        module Concerns
          module SetCriteria
            def initialize(*args)
              super

              set_criteria if entity.id
            end

            private

            def set_criteria
              self.criteria = if options[:via]
                criteria_for_reverse_mapping
              else
                criteria_for_normal_mapping
              end
            end

            def criteria_for_normal_mapping
              { key_name => entity.id }
            end
          end
        end
      end
    end
  end
end
