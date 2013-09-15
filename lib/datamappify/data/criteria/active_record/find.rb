require 'datamappify/data/criteria/relational/concerns/find'
require 'datamappify/data/criteria/active_record/criteria_method'

module Datamappify
  module Data
    module Criteria
      module ActiveRecord
        class Find < CriteriaMethod
          include Relational::Concerns::Find

          private

          def record
            records_scope.where(criteria).first
          end
        end
      end
    end
  end
end
