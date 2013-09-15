require 'datamappify/data/criteria/relational/concerns/find_by_key'

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
