module Datamappify
  module Entity
    module Association
      # Compatibility layer for ActionView
      module Compatibility
        # Adds `association_name_attributes` as required by
        # nested attributes assignment
        #
        # @param (see DSL#has_many)
        def has_many(name, options = {})
          super(name, options)

          self.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def #{name}_attributes=(params = {})
              params.each do |index, attributes|
                self.#{name} << #{options[:via]}.new(attributes)
              end
            end
          CODE
        end
      end
    end
  end
end
