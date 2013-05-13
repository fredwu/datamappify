require 'datamappify/repository/query_method/method/source_attributes_walker'

module Datamappify
  module Lazy
    class SourceAttributesWalker < Repository::QueryMethod::Method::SourceAttributesWalker
      private

      # @param (see Repository::QueryMethod::Method::SourceAttributesWalker#do_walk?)
      #
      # @see Repository::QueryMethod::Method::SourceAttributesWalker#do_walk?
      #
      # @return (see Repository::QueryMethod::Method::SourceAttributesWalker#do_walk?)
      def do_walk?(source_class, attributes)
        read_only? ? default_source_class?(source_class) : true
      end

      # @param (see Repository::QueryMethod::Method::SourceAttributesWalker#walk_performed)
      #
      # @see Repository::QueryMethod::Method::SourceAttributesWalker#walk_performed
      #
      # @return (see Repository::QueryMethod::Method::SourceAttributesWalker#walk_performed)
      def walk_performed(attributes)
        attributes.each do |attribute|
          @entity.cached_attributes[attribute.key] = attribute.value
        end

        @entity.changed
        @entity.notify_observers(@query_method, attributes)

        super
      end

      # @param source_class [Class]
      #
      # @return [Boolean]
      def default_source_class?(source_class)
        @entity.repository.data_mapper.default_source_class == source_class
      end

      # Whether the walker is in read-only mode, it is determined from
      # the {Repository::QueryMethod::Method query method} if available
      #
      # @return [Boolean]
      def read_only?
        !!@query_method && @query_method.reader?
      end
    end
  end
end
