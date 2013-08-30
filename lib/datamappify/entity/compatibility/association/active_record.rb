module Datamappify
  module Entity
    module Compatibility
      module Association
        # Compatibility layer for ActionRecord
        module ActiveRecord
          # Adds `association_name_attributes` as required by
          # nested attributes assignment
          #
          # @param (see DSL#has_many)
          def has_many(name, options = {})
            super

            self.class_eval <<-CODE, __FILE__, __LINE__ + 1
              def #{name}_attributes=(params = {})
                new_entites = params.map do |index, attributes|
                  #{options[:via]}.new(attributes)
                end

                self.#{name} = self.#{name}.map do |entity|
                  new_entites.detect { |e| e.id == entity.id } || entity
                end

                new_entites.each do |entity|
                  entity_is_already_added = entity.id && self.#{name}.map(&:id).include?(entity.id)

                  unless entity_is_already_added
                    self.#{name} << entity
                  end
                end
              end
            CODE
          end
        end
      end
    end
  end
end
