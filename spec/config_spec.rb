require 'spec_helper'

describe Datamappify do
  context 'defaults' do
    subject { Datamappify.defaults }

    its(:default_provider) { should be_nil }
    its(:automap)          { should == true }
  end

  context 'when configured' do
    before do
      Datamappify.config do |c|
        c.default_provider = :ActiveRecord
        c.automap          = false
      end
    end

    describe 'defaults' do
      subject { Datamappify.defaults }

      its(:default_provider) { should == :ActiveRecord }
      its(:automap)          { should == false }
    end

    describe 'mapper' do
      subject { Datamappify::Data::Mapper.new }

      its(:default_provider_name) { should == :ActiveRecord }
      its(:automap)               { should == false }
    end
  end
end
