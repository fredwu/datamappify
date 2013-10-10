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
            case reference_type
            when :one
              @entity.send("#{@reference_name}=", fetch_referenced_entity)
            when :many
              @entity.send("#{@reference_name}=", fetch_referenced_entities)
            end
          end

          # @return [void]
          def perform_write
            referenced_entities.each do |entity|
              if entity.destroy?
                if entity.persisted?
                  @repository.destroy!(entity)
                end
              else
                entity.send("#{reference_key}=", @entity.id)
                @repository.states.mark_as_dirty(entity)
                @repository.save!(entity)
              end
            end
          end

          # @return [Symbol]
          #   :one or :many
          def reference_type
            reference = @entity.send(:attribute_set).detect do |attr|
              attr.name == @reference_name
            end

            case reference
            when Virtus::Attribute::EmbeddedValue then :one
            when Virtus::Attribute::Collection    then :many
            end
          end

          # @return [Entity]
          def fetch_referenced_entity
            @repository.where(reference_key => @entity.id).first
          end

          # @return [Array<Entity>]
          def fetch_referenced_entities
            @repository.where(reference_key => @entity.id)
          end

          # @return [Array<Entity>]
          def referenced_entities
            Array.wrap(@entity.send(@reference_name))
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
