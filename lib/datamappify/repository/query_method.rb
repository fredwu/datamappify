require 'datamappify/repository/query_method/helper'

Dir[Datamappify.root.join('repository/query_method/*')].each { |file| require file }
