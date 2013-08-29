require 'observer'
require 'virtus'
require 'datamappify/entity/compatibility/active_model'
require 'datamappify/entity/lazy_checking'
require 'datamappify/entity/composable'
require 'datamappify/entity/association'
require 'datamappify/entity/inspectable'

module Datamappify
  module Entity
    def self.included(klass)
      klass.class_eval do
        include Observable
        include ::ActiveModel::Model
        include Compatibility::ActiveModel
        include Virtus
        include Virtus::Equalizer.new(inspect)
        include LazyChecking
        include Composable
        include Association
        include Inspectable

        attribute :id, Integer
      end
    end
  end
end
