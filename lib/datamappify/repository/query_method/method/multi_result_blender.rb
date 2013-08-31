module Datamappify
  module Repository
    module QueryMethod
      class Method
        class MultiResultBlender
          # @param method_instance [Method]
          def initialize(method_instance)
            @method = method_instance
          end

          # @param results [Array<Entity>]
          #
          # @return [Array<Entity>]
          def blend(results)
            results.each do |entity|
              @method.states.find(entity)
              @method.walk_references(:Find, entity)
            end
          end
        end
      end
    end
  end
end
