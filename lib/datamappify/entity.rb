require 'virtus'
require 'datamappify/entity/association_methods'

module Datamappify
  module Entity
    def self.included(klass)
      klass.class_eval do
        include Virtus

        attribute :id, Integer

        extend Behaviour
        extend Structure
        extend AssociationMethods
      end
    end

    module Behaviour
      def self.extended(klass)
        klass.class_eval do
          include ActiveModel::Validations
        end
      end

      attr_accessor :stored_validations

      def validations(&block)
        self.stored_validations = block

        instance_eval(&block)
      end
    end

    module Structure
      attr_accessor :stored_relationships

      def relationships(&block)
        self.stored_relationships = block

        instance_eval(&block)
      end
    end
  end
end
