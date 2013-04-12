require 'datamappify/repository/query_method/method'

Dir[Datamappify.root.join('repository/query_method/*')].each { |file| require file }
