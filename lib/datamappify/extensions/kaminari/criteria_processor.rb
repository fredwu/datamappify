module Datamappify
  module Extensions
    module Kaminari
      module CriteriaProcessor
        # @see (Repository::QueryMethods#criteria)
        def criteria(criteria)
          process_criteria!(criteria)

          collection = super

          collection.limit_value  = @limit
          collection.offset_value = @offset
          collection.total_count  = count(criteria.except(:limit))

          collection
        end

        private

        # @see (Repository::QueryMethods#criteria)
        def process_criteria!(criteria)
          if (page = criteria.delete(:page).try(:to_i)) && (per = criteria.delete(:per).try(:to_i))
            @limit  = per
            @offset = ([page, 1].max - 1) * per

            criteria[:limit] = [@limit, @offset]
          end
        end
      end
    end
  end
end
