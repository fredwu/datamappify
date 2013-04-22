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
          # @return [Class]
          #   the data record class
          def find_or_build_record_class(source_class_name)
            if records_namespace.const_defined?(source_class_name, false)
              records_namespace.const_get(source_class_name)
            else
              build_record_class(source_class_name)
            end
          end

          private

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
          Data::Criteria.const_get(class_name).const_get(name).new(*args, &block).perform
        end
      end
    end
  end
end
