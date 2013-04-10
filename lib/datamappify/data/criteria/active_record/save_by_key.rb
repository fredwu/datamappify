require 'datamappify/data/criteria/relational/save_by_key'
require 'datamappify/data/criteria/active_record/save'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class SaveByKey < Save
          include Relational::SaveByKey
        end
      end
    end
  end
end
