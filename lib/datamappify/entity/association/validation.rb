module Datamappify
  module Entity
    module Association
      # Passes referenced validation errors onto the main entity
      module Validation
        def self.included(klass)
          klass.class_eval do
            attr_accessor :referenced_errors

            validate :association_validation

            def referenced_errors
              @referenced_errors ||= {}
            end
          end
        end

        # @param context [Symbol]
        #   e.g. :create or :update
        #
        # @return [Boolean]
        def valid?(context = nil)
          aggregate_validation_errors(context)

          super
        end

        private

        # @param (see #valid?)
        #
        # @return [void]
        def aggregate_validation_errors(context)
          self.associations.each do |association|
            self.send(association).reject(&:destroy?).each do |entity|
              entity.invalid?(context) && referenced_entity_validation_errors(entity)
            end
          end
        end

        # @param (see #valid?)
        #
        # @return [void]
        def referenced_entity_validation_errors(entity)
          entity.errors.messages.each do |attr, msgs|
            self.referenced_errors["#{entity.class.model_name.element}__#{attr}"] = msgs
          end
        end

        # @return [void]
        def association_validation
          self.referenced_errors.each do |name, msgs|
            self.errors.add name, msgs.join(', ')
          end
        end
      end
    end
  end
end
