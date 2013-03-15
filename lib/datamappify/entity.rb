require 'virtus'

module Datamappify
  module Entity
    def self.included(klass)
      klass.class_eval do
        include Virtus
        include Virtus::Equalizer.new(inspect)
        include ActiveModel::Validations

        attribute :id, Integer
      end
    end
  end
end
