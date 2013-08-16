module Datamappify
  module Repository
    module QueryMethod
      class Method
        class ReferenceHandler
          def initialize(options = {})
            @entity         = options[:entity]
            @criteria_name  = options[:criteria_name]
            @reference_name = options[:reference_name]
            @repository     = options[:reference_options][:via]
            @query_method   = options[:query_method]
          end

          # @return [void]
          def execute
            perform_read  if @query_method.reader?
            perform_write if @query_method.writer?
          end

          private

          # @return [void]
          def perform_read
            @entity.send("#{@reference_name}=", fetch_referenced_entities)
          end

          # @return [void]
          def perform_write
            referenced_entities.each do |entity|
              entity.send("#{reference_key}=", @entity.id)
              @repository.save!(entity)
            end
          end

          # @return [Array]
          def fetch_referenced_entities
            @repository.where(reference_key => @entity.id)
          end

          # @return [Array]
          def referenced_entities
            @entity.send(@reference_name)
          end

          # @return (see Data::Mapper::Attribute#reference_key)
          def reference_key
            @query_method.data_mapper.attributes.first.reference_key
          end
        end
      end
    end
  end
end
