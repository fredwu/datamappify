module Datamappify
  module Data
    module Provider
      module CommonProvider
        def self.extended(klass)
          klass.extend ModuleMethods

          klass.load_criterias
        end

        module ModuleMethods
          # Loads all the criteria files from the data provider
          #
          # @return [void]
          def load_criterias
            Dir[Datamappify.root.join("data/criteria/#{path_name}/*.rb")].each { |file| require file }
          end

          # Non-namespaced class name
          #
          # @return [String]
          def class_name
            @class_name ||= name.demodulize
          end

          # @return [String]
          def path_name
            @path_name ||= class_name.underscore
          end

          # Finds or builds a data record class from the data provider
          #
          # @param source_class_name [String]
          #
          # @return [Class]
          #   the data record class
          def find_or_build_record_class(source_class_name)
            namespace    = build_or_return_namespace(source_class_name)
            record_class = source_class_name.safe_constantize

            # check for existing record class
            if record_class && !entity_class?(source_class_name)
              record_class

            # check for existing record class in the Datamappify::Data::Record::Provider namespace
            elsif namespace.const_defined?(source_class_name.demodulize, false)
              namespace.const_get(source_class_name.demodulize)

            # no existing record class is found, let's build it
            else
              build_record_class(source_class_name)
            end
          end

          private

          # @return [Boolean]
          def entity_class?(source_class_name)
            source_class_name.constantize.ancestors.include?(Datamappify::Entity)
          end

          # Builds or returns the namespace for the source class
          #
          # @param source_class_name [String]
          #
          # @return [Module]
          def build_or_return_namespace(source_class_name)
            source_class_name.deconstantize.split('::').inject(records_namespace) do |namespaces, namespace|
              if namespaces.const_defined?(namespace, false)
                namespaces.const_get(namespace)
              else
                namespaces.const_set(namespace, Module.new)
              end
            end
          end

          # The namespace for the data records, e.g. +Datamappify::Data::Record::ActiveRecord+
          #
          # @return [Module]
          def records_namespace
            @records_namespace ||= Data::Record.const_set(class_name, Module.new)
          end
        end

        # Builds a {Criteria}
        #
        # @param name [Symbol]
        #
        # @param args [any]
        #
        # @yield
        #   an optional block passed to the +Criteria+ {Criteria::Common#initialize initialiser}
        def build_criteria(name, *args, &block)
          Data::Criteria.const_get(class_name).const_get(name).new(*args, &block).perform_with_callbacks
        end
      end
    end
  end
end
