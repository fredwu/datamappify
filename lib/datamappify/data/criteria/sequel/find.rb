require 'datamappify/data/criteria/relational/concerns/find'

module Datamappify
  module Data
    module Criteria
      module Sequel
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
