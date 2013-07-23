require 'spec_helper'

describe Datamappify do
  before do
    Datamappify.config do |c|
      c.default_provider = :ActiveRecord
    end
  end

  it "#default_provider" do
    mapper = Datamappify::Data::Mapper.new
    mapper.default_provider_name.should == :ActiveRecord
  end
end
