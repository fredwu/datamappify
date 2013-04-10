require 'datamappify/data/provider/common_provider'

module Datamappify
  module Data
    module Provider
      extend ActiveSupport::Autoload

      autoload :ActiveRecord
      autoload :Sequel
    end
  end
end
