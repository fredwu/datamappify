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
