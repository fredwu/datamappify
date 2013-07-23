require 'datamappify/repository/lazy_checking'
require 'datamappify/repository/mapping_dsl'
require 'datamappify/repository/unit_of_work'
require 'datamappify/repository/query_methods'
require 'datamappify/repository/inheritable'
require 'datamappify/data'

module Datamappify
  module Repository
    # @return [Data::Mapper]
    attr_accessor :data_mapper

    # @return [UnitOfWork::PersistentStates]
    attr_reader :states

    def self.included(klass)
      klass.class_eval do
        include Singleton
        extend  SingletonWrapper

        class_attribute :current_group_options
        self.current_group_options = {}

        self.data_mapper = Data::Mapper.new

        include LazyChecking
        extend  MappingDSL
        include QueryMethods
        extend  Inheritable
      end
    end

    private

    def initialize
      @states = UnitOfWork::PersistentStates.new
    end

    # Wraps a ruby Singleton class so that calling `instance` is no longer necessary.
    #
    # @example With `instance`
    #   UserRepository.instance.count
    #
    # @example Without `instance`
    #   UserRepository.count
    module SingletonWrapper
      def self.extended(klass)
        class << klass
          extend Forwardable
          def_delegators :instance, :data_mapper, :data_mapper=, :states
          def_delegators :instance, *QueryMethods.instance_methods
        end
      end
    end
  end
end
