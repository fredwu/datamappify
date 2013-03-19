require 'datamappify/data/provider/common/relational/persistence'
require 'datamappify/data/provider/common/relational/record/mapper'
require 'datamappify/data/provider/common/relational/record/writer'

module Datamappify
  module Data
    module Provider
      module Sequel
        class Persistence < Data::Provider::Common::Relational::Persistence
          def destroy(ids)
            data_class.where(:id => ids).destroy
          end

          def exists?(id)
            data_class.where(:id => id).any?
          end

          def transaction(&block)
            data_class.db.transaction(&block)
          end

          private

          def record_attributes_method
            :values
          end
        end
      end
    end
  end
end
