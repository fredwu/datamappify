require 'datamappify/data/criteria/relational/concerns/find_by_key'
require 'datamappify/data/criteria/active_record/find'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class FindByKey < Find
          include Relational::Concerns::FindByKey
        end
      end
    end
  end
end
