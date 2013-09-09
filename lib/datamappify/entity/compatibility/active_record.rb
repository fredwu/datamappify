module Datamappify
  module Entity
    module Compatibility
      # Add non-entity related stuff so that an entity can be used in say, forms
      module ActiveRecord
        # @return [Array<Symbol>]
        IGNORED_ATTRIBUTE_NAMES = [:_destroy]

        def self.included(klass)
          klass.class_eval do
            attribute :_destroy, Virtus::Attribute::Boolean, :default => false
          end
        end

        # @return [Boolean]
        def destroy?
          !!_destroy
        end
      end
    end
  end
end
