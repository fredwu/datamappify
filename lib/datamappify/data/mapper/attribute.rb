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

        # @return [any]
        attr_accessor :value

        # @param name [Symbol]
        #   name of the attribute
        #
        # @param source [String]
        #   data provider, class and attribute,
        #   e.g. "ActiveRecord::User#surname"
        #
        # @param primary_source_class [Class]
        def initialize(name, source, primary_source_class)
          @key                  = name
          @name                 = name.to_s
          @primary_source_class = primary_source_class

          @provider_name, @source_class_name, @source_attribute_name = parse_source(source)

          unless primary_attribute? || external_attribute?
            Record.build_association(self, primary_source_class)
          end
        end

        # @example
        #
        #   UserComment
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
          @source_name ||= source_class_name.underscore
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

        # @example
        #
        #   :user_comment_id
        #
        # @return [Symbol]
        def source_reference_key
          @source_reference_key ||= :"#{source_name}_id"
        end

        # @return [Boolean]
        def primary_key?
          source_attribute_name == 'id'
        end

        # @return [Boolean]
        def primary_attribute?
          provider_name == primary_provider_name && primary_source_class == source_class
        end

        # External attribute is from a different data provider than the primary data provider
        #
        # @return [Boolean]
        def external_attribute?
          provider_name != primary_provider_name
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

        private

        # @return [Array<String>]
        #   an array with provider name, source class name and source attribute name
        def parse_source(source)
          provider_name, source_class_and_attribute = source.split('::')

          [provider_name, *source_class_and_attribute.split('#')]
        end
      end
    end
  end
end
