require 'spec_helper'

describe Datamappify::Data::Mapper::Attribute do
  DATA_PROVIDERS.each do |data_provider|
    describe data_provider do
      let(:data_provider_class) { "Datamappify::Data::Provider::#{data_provider}".constantize }

      let(:record_class) { data_provider_class.find_or_build_record_class('Fridge::Freezer') }

      subject { described_class.new(:door,
                                    to: 'Fridge::Freezer#door_handle',
                                    provider: data_provider,
                                    primary_source_class: record_class ) }

      its(:provider_name)         { should == data_provider }
      its(:key)                   { should == :door }
      its(:name)                  { should == 'door' }
      its(:source_attribute_name) { should == 'door_handle' }
      its(:source_class_name)     { should == 'Fridge::Freezer' }
      its(:source_table)          { should == :fridge_freezers }
    end
  end
end
