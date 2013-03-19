module Datamappify
  module Repository
    class MappingHash < Hash
      alias :field_names :keys
      alias :attribute_names :values
    end
  end
end
