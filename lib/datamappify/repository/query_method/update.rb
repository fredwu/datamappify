require 'datamappify/repository/query_method/save'

module Datamappify
  module Repository
    module QueryMethod
      class Update < Save
        # @see Method#dirty_aware?
        def dirty_aware?
          true
        end
      end
    end
  end
end
