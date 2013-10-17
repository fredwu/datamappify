require 'hooks'

module Datamappify
  module Repository
    module QueryMethod
      module Callbacks
        def self.included(klass)
          klass.class_eval do
            include Hooks

            define_hooks :before_load,    :after_load,
                         :before_find,    :after_find,
                         :before_create,  :after_create,
                         :before_update,  :after_update,
                         :before_save,    :after_save,
                         :before_destroy, :after_destroy,
                         :halts_on_falsey => true
          end
        end

        # @param entity [Entity]
        #
        # @param types (see #_run_callbacks)
        #
        # @yield (see #_run_callbacks)
        #
        # @return [void]
        def run_callbacks(entity, *types, &block)
          _run_callbacks(false, entity, *types, &block)
        end

        # @param criteria [any]
        #
        # @param types (see #_run_callbacks)
        #
        # @yield (see #_run_callbacks)
        #
        # @return [void]
        def run_callbacks_and_return_entity(criteria, *types, &block)
          _run_callbacks(true, criteria, *types, &block)
        end

        private

        # @param return_yield_value [Boolean]
        #
        # @param input [any]
        #
        # @param types [Symbol]
        #   e.g. :create, :update, :save or :destroy
        #
        # @yield callback
        #
        # @return [void]
        def _run_callbacks(return_yield_value, input, *types, &block)
          run_hooks(types, :before, input) &&
            (yield_value = block.call) &&
            run_hooks(types.reverse, :after, (return_yield_value ? yield_value : input)) &&
            yield_value
        end

        # @param types [Array<Symbol]
        #   an array of types (e.g. :create, :update, :save or :destroy)
        #
        # @param filter [Symbol]
        #   e.g. :before or :after
        #
        # @param entity [Entity]
        #
        # @return [Boolean]
        def run_hooks(types, filter, entity)
          types.take_while do |type|
            run_hook(hook_for(type, filter), entity).not_halted?
          end.length == types.length
        end

        # @param type [Symbol]
        #   e.g. :create, :update, :save or :destroy
        #
        # @param filter [Symbol]
        #   e.g. :before or :after
        #
        # @return [Symbol]
        def hook_for(type, filter)
          :"#{filter}_#{type}"
        end
      end
    end
  end
end
