require 'spec_helper'

describe Datamappify::Entity do
  subject do
    Computer.new({
      :brand               => 'Fruit',
      :cpu                 => '286',
      :ram                 => 8192,
      :hdd                 => 65536,
      :gfx                 => 'Voodoo',
      :vendor              => 'Compaq',
      :software_os         => 'OS X',
      :software_osx_id     => 1,
      :software_windows_id => 2,
      :software_linux_id   => 3,
      :software_vendor     => 'Lotus'
    })
  end

  its(:cpu)                 { should == '286' }
  its(:ram)                 { should == 8192 }
  its(:hdd)                 { should == 65536 }
  its(:gfx)                 { should == 'Voodoo' }
  its(:vendor)              { should == 'Compaq' }
  its(:software_os)         { should == 'OS X' }
  its(:software_osx_id)     { should == 1 }
  its(:software_windows_id) { should == 2 }
  its(:software_linux_id)   { should == 3 }
  its(:software_vendor)     { should == 'Lotus' }

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
