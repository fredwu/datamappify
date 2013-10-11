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
          # a minimal compatibility implementation needed by nested_form
          #
          # @see: https://github.com/ryanb/nested_form/blob/68485d/lib/nested_form/builder_mixin.rb#L28
          def reflect_on_association(association)
            if member_type = self.attribute_set.detect { |a| a.name == association }.try(:member_type)
              Struct.new(:klass).new(member_type.primitive)
            end
          end
        end
      end
    end
  end
end
