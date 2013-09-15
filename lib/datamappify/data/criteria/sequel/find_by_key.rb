require 'datamappify/data/criteria/relational/concerns/find_by_key'
require 'datamappify/data/criteria/sequel/find'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class FindByKey < Find
          include Relational::Concerns::FindByKey
        end
      end
    end
  end
end
