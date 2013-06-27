require 'spec_helper'

describe Datamappify::Entity do
  subject do
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
  end

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

  describe "validation" do
    context "valid" do
      it { should be_valid }
    end

    context "invalid" do
      after do
        subject.should be_invalid
      end

      it('brand')       { subject.brand       = nil }
      it('ram')         { subject.ram         = 42 }
      it('hdd')         { subject.hdd         = 42 }
      it('hdd')         { subject.hdd         = 65537 }
      it('software_os') { subject.software_os = nil }
    end
  end
end
