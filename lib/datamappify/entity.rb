require 'observer'
require 'virtus'
require 'datamappify/entity/active_model/compatibility'
require 'datamappify/entity/lazy_checking'

module Datamappify
  module Entity
    def self.included(klass)
      klass.class_eval do
        include Observable
        include Virtus
        include Virtus::Equalizer.new(inspect)
        include ::ActiveModel::Model
        include ActiveModel::Compatibility
        include LazyChecking

        attribute :id, Integer
      end
    end
  end
end
