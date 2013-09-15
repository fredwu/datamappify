module Datamappify
  module Repository
    module QueryMethod
      class Method
        # Walks through the attributes of the source classes under a provider (e.g. ActiveRecord),
        # the walker is aware of the dirty state so that certain operations (i.e. #save) can be bypassed
        class SourceAttributesWalker
          def initialize(options = {})
            @entity           = options[:entity]
            @provider_name    = options[:provider_name]
            @attributes       = options[:attributes]
            @dirty_aware      = options[:dirty_aware?]
            @dirty_attributes = options[:dirty_attributes]
            @query_method     = options[:query_method]
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
          # @yieldreturn [void]
          #
          # @return [void]
          def execute(&block)
            if @query_method && @query_method.writer?
              @attributes.classify(&:source_class).each do |source_class, attributes|
                perform_walk(source_class, attributes, &block)
              end
            else
              perform_walk(@attributes.first.source_class, @attributes, &block)
            end
          end

          private

          # @param source_class [Class]
          #
          # @param attributes [Set<Data::Mapper::Attribute>]
          #
          # @yield (see #execute)
          #
          # @return [void]
          def perform_walk(source_class, attributes, &block)
            if do_walk?(source_class, attributes)
              block.call(@provider_name, source_class, attributes)
              walk_performed(attributes)
            end
          end

          # Whether it is necessary to do the walk
          #
          # @param source_class [Class]
          #
          # @param attributes [Set<Data::Mapper::Attribute>]
          #
          # @return [Boolean]
          def do_walk?(source_class, attributes)
            check_dirty?(attributes)
          end

          # A hook method for when a walk is performed
          #
          # @param attributes [Set<Data::Mapper::Attribute>]
          #
          # @return [void]
          def walk_performed(attributes)
            Logger.performed(@query_method && @query_method.class)
          end

          # Only walk when it's not dirty aware, or it has dirty attributes
          #
          # @param attributes [Set<Data::Mapper::Attribute>]
          #
          # @return [Boolean]
          def check_dirty?(attributes)
            !@dirty_aware || dirty?(attributes)
          end

          # Whether the persistent state object is dirty
          #
          # @param (see #do_walk?)
          #
          # @return [Boolean]
          def dirty?(attributes)
            (attributes.map(&:key) & @dirty_attributes).any?
          end
        end
      end
    end
  end
end
