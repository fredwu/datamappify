require 'spec_helper'

shared_examples_for "namespaced mapping" do |data_provider|
  let!(:computer_repository) { "ComputerRepository#{data_provider}".constantize }
  let(:new_computer) {
    Computer.new({
      :brand               => 'Fruit',
      :cpu                 => '286',
      :ram                 => 4242,
      :gfx                 => 'Voodoo',
      :vendor              => 'Compaq',
      :software_os         => 'OS X',
      :software_vendor     => 'Apple',
      :game_os             => 'Orbit OS',
      :game_vendor         => 'SONY'
    })
  }

  context "#{data_provider}" do
    describe "entity" do
      let!(:computer) { computer_repository.save!(new_computer) }

      subject { computer_repository.find(computer.id) }

      its(:brand)           { should == 'Fruit' }
      its(:cpu)             { should == '286' }
      its(:ram)             { should == 4242 }
      its(:hdd)             { should == 65536 }
      its(:gfx)             { should == 'Voodoo' }
      its(:vendor)          { should == 'Compaq' }
      its(:software_os)     { should == 'OS X' }
      its(:software_vendor) { should == 'Apple' }
      its(:game_os)         { should == 'Orbit OS' }
      its(:game_vendor)     { should == 'SONY' }
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "namespaced mapping", data_provider
  end
end
