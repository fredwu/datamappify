require 'datamappify/data/criteria/relational/save_by_key'
require 'datamappify/data/criteria/sequel/save'

module Datamappify
  module Data
    module Criteria
      module Sequel
        class SaveByKey < Save
          include Relational::SaveByKey
        end
      end
    end
  end
end
