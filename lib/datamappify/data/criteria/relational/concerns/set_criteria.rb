module Datamappify
  module Data
    module Criteria
      module Relational
        module Concerns
          module SetCriteria
            def initialize(*args)
              super

              if entity.id
                self.criteria = build_criteria
              end
            end

            private

            def build_criteria
              if options[:via].nil?
                criteria_for_normal_mapping
              elsif finder?
                criteria_for_reverse_mapping
              else
                {}
              end
            end

            def criteria_for_reverse_mapping
              reverse_id = options[:primary_record].send(options[:via])
              reverse_id ? { :id => reverse_id } : {}
            end

            def criteria_for_normal_mapping
              { key_name => entity.id }
            end

            def finder?
              self.class.name =~ /Find/
            end
          end
        end
      end
    end
  end
end
