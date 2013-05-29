require 'spec_helper'

describe Datamappify::Entity do
  subject { Computer.new }

  before do
    subject.cpu                 = '286'
    subject.ram                 = 8192
    subject.hdd                 = 65536
    subject.gfx                 = 'Voodoo'
    subject.software_os         = 'OS X'
    subject.software_osx_id     = 1
    subject.software_windows_id = 2
    subject.software_linux_id   = 3
  end

  its(:cpu)                 { should == '286' }
  its(:ram)                 { should == 8192 }
  its(:hdd)                 { should == 65536 }
  its(:gfx)                 { should == 'Voodoo' }
  its(:software_os)         { should == 'OS X' }
  its(:software_osx_id)     { should == 1 }
  its(:software_windows_id) { should == 2 }
  its(:software_linux_id)   { should == 3 }
end
