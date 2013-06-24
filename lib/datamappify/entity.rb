require 'observer'
require 'virtus'
require 'datamappify/entity/active_model/compatibility'
require 'datamappify/entity/lazy_checking'
require 'datamappify/entity/composable'
require 'datamappify/entity/relation'

module Datamappify
  module Entity
    def self.included(klass)
      klass.class_eval do
        include Observable
        include ::ActiveModel::Model
        include ActiveModel::Compatibility
        include Virtus
        include Virtus::Equalizer.new(inspect)
        include LazyChecking
        include Composable
        include Relation

        attribute :id, Integer
      end
    end
  end
end
