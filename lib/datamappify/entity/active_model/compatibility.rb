module Datamappify
  module Entity
    module ActiveModel
      # Add non-entity related stuff so that an entity can be used in say, forms
      module Compatibility
        # @return [Boolean]
        def persisted?
          !id.blank?
        end
      end
    end
  end
end
