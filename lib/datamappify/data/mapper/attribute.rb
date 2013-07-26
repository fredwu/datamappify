module Datamappify
  module Data
    class Mapper
      # Represents an entity attribute and its associated data source
      class Attribute
        # Same as name, but in symbol
        #
        # @return [Symbol]
        attr_reader :key

        # @return [String]
        attr_reader :name

        # @return [String]
        attr_reader :provider_name

        # @return [String]
        attr_reader :source_class_name

        # @return [String]
        attr_reader :source_attribute_name

        # @return [Class]
        attr_reader :primary_source_class

        # @return [Hash]
        attr_reader :options

        # @return [any]
        attr_accessor :value

        # @param name [Symbol]
        #   name of the attribute
        #
        # @param options [Hash]
        def initialize(name, options)
          @key                  = name
          @name                 = name.to_s
          @options              = options
          @provider_name        = options[:provider].to_s
          @primary_source_class = options[:primary_source_class]

          @source_class_name, @source_attribute_name = parse_source(options[:to])

          if secondary_attribute?
            if reverse_mapped?
              Record.build_reversed_association(self, primary_source_class)
            else
              Record.build_association(self, primary_source_class)
            end
          end
        end

        # @example
        #
        #   Namespaced::UserComment
        #
        # @return [Class]
        def source_class
          @source_class ||= Record.find_or_build(provider_name, source_class_name)
        end

        # @example
        #
        #   "user_comment"
        #
        # @return [String]
        def source_name
          @source_name ||= source_class_name.demodulize.underscore
        end

        # @example
        #
        #   :user_comment
        #
        # @return [Symbol]
        def source_key
          @source_key ||= source_name.to_sym
        end

        # @example
        #
        #   :title
        #
        # @return [Symbol]
        def source_attribute_key
          @source_attribute_key ||= source_attribute_name.to_sym
        end

        # @example
        #
        #   :user_comments
        #
        # @return [Symbol]
        def source_table
          @source_table ||= source_class_name.pluralize.underscore.to_sym
        end

        # @return [Boolean]
        def primary_key?
          source_attribute_name == 'id'
        end

        # @return [String]
        def primary_provider_name
          @primary_provider_name ||= primary_source_class.parent.to_s.demodulize
        end

        # Foreign key of the primary record, useful for joins
        #
        # @example
        #
        #   :user_id
        #
        # @return [Symbol]
        def primary_reference_key
          @primary_reference_key ||= :"#{primary_source_class.to_s.demodulize.underscore}_id"
        end

        # Primary attribute is from the same data provider and the same source class
        #
        # @return [Boolean]
        def primary_attribute?
          provider_name == primary_provider_name && primary_source_class == source_class
        end

        # Secondary attribute is from the same data provider but a different source class
        #
        # @return [Boolean]
        def secondary_attribute?
          provider_name == primary_provider_name && primary_source_class != source_class
        end

        # @return [Boolean]
        def reverse_mapped?
          !!@options[:via]
        end

        private

        # @return [Array<String>]
        #   an array with provider name, source class name and source attribute name
        def parse_source(source)
          source.split('#')
        end
      end
    end
  end
end
