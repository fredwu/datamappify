module Datamappify
  module Entity
    module Compatibility
      # Add non-entity related stuff so that an entity can be used in say, forms
      module ActiveRecord
        # @return [Array<Symbol>]
        IGNORED_ATTRIBUTE_NAMES = [:_destroy]

        def self.included(klass)
          klass.class_eval do
            extend ClassMethods
            attribute :_destroy, Virtus::Attribute::Boolean, :default => false
          end
        end

        # @return [Boolean]
        def destroy?
          !!_destroy
        end

        module ClassMethods
          # @return [Struct]
          def reflect_on_association(association)
            attribute = attribute_set.detect { |attribute| attribute.name == association }
            if attribute
              klass = attribute.writer.member_type.name.constantize
              Struct.new(:klass).new(klass)
            end
          end
        end
      end
    end
  end
end
