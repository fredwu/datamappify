module Datamappify
  module Repository
    module QueryMethod
      class Method
        # Walks through the attributes of the source classes under a provider (e.g. ActiveRecord),
        # the walker is aware of the dirty state so that certain operations (i.e. #save) can be bypassed
        class SourceAttributesWalker
          def initialize(options = {})
            @entity        = options[:entity]
            @provider_name = options[:provider_name]
            @attributes    = options[:attributes]
            @query_method  = options[:query_method]
          end

          # @yield [provider_name, source_class, attributes]
          #   action to be performed on the attributes grouped by their source class
          #
          # @yieldparam provider_name [String]
          #
          # @yieldparam source_class [Class]
          #
          # @yieldparam attributes [Set<Data::Mapper::Attribute>]
          #
          # @return [void]
          def execute(&block)
            @attributes.classify(&:source_class).each do |source_class, attributes|
              if do_walk?(attributes)
                block.call(@provider_name, source_class, attributes)
                @query_method.class.send :performed
              end
            end
          end

          private

          # Whether it is necessary to do the walk
          #
          # @param attributes [Set<Data::Mapper::Attribute>]
          #
          # @return [Boolean]
          def do_walk?(attributes)
            !@query_method.dirty_aware? || dirty?(attributes)
          end

          # Whether the persistent state object is dirty
          #
          # @param (see #do_walk?)
          #
          # @return [Boolean]
          def dirty?(attributes)
            (attributes.map(&:key) & @query_method.states.find(@entity).changed).any?
          end
        end
      end
    end
  end
end
