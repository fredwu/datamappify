module Datamappify
  module Entity
    module Compatibility
      # Add non-entity related stuff so that an entity can be used in say, forms
      module ActiveModel
        # @return [Boolean]
        def persisted?
          !id.blank?
        end
      end
    end
  end
end
