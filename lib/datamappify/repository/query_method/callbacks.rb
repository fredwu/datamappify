require 'hooks'

module Datamappify
  module Repository
    module QueryMethod
      module Callbacks
        def self.included(klass)
          klass.class_eval do
            include Hooks

            define_hooks :before_create,  :after_create,
                         :before_update,  :after_update,
                         :before_save,    :after_save,
                         :before_destroy, :after_destroy
          end
        end

        # @param entity [Entity]
        #
        # @param types [Symbol]
        #   e.g. :create, :update, :save or :destroy
        #
        # @yield callback
        #
        # @return [void]
        def run_callbacks(entity, *types, &block)
          run_hooks(types, :before, entity) &&
            block.call &&
            run_hooks(types.reverse, :after, entity)
        end

        private

        # @param types [Array<Symbol]
        #   an array of types (e.g. :create, :update, :save or :destroy)
        #
        # @param filter [Symbol]
        #   e.g. :before or :after
        #
        # @param entity [Entity]
        #
        # @return [void]
        def run_hooks(types, filter, entity)
          types.each do |type|
            run_hook hook_for(type, filter), entity
          end

          entity
        end

        # @param type [Symbol]
        #   e.g. :create, :update, :save or :destroy
        #
        # @param filter [Symbol]
        #   e.g. :before or :after
        #
        # @return [String]
        def hook_for(type, filter)
          "#{filter}_#{type}"
        end
      end
    end
  end
end
