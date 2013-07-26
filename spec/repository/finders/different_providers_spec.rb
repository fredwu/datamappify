require 'spec_helper'

describe "attributes from different data providers" do
  before do
    pending

    HeroUserRepository.save!(HeroUser.new(:first_name => 'Fred', :last_name => 'Wu'))
    HeroUserRepository.save!(HeroUser.new(:first_name => 'Sheldon', :last_name => 'Cooper'))
    HeroUserRepository.save!(HeroUser.new(:first_name => 'Fred', :last_name => 'Cooper'))
  end

  context "example 1" do
    let(:records) { HeroUserRepository.find(:first_name => 'Fred') }
    subject       { records }

    it { should have(2).users }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Fred' }
      its(:last_name)  { should == 'Wu' }
    end
  end

  context "example 2" do
    let(:records) { HeroUserRepository.find(:first_name => 'Sheldon') }
    subject       { records }

    it { should have(1).user }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Sheldon' }
      its(:last_name)  { should == 'Cooper' }
    end
  end

  context "example 3" do
    let(:records) { HeroUserRepository.find(:last_name => 'Cooper') }
    subject       { records }

    it { should have(2).users }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Sheldon' }
      its(:last_name)  { should == 'Cooper' }
    end
  end

  context "example 4" do
    let(:records) { HeroUserRepository.find(:first_name => 'Sheldon', :last_name => 'Cooper') }
    subject       { records }

    it { should have(1).user }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Sheldon' }
      its(:last_name)  { should == 'Cooper' }
    end
  end

  context "example 5" do
    let(:records) { HeroUserRepository.find(:first_name => 'Leonard', :last_name => 'Cooper') }
    subject       { records }

    it { should be_empty }
  end

  context "example 6" do
    let(:records) { HeroUserRepository.find(:first_name => 'Fred', :last_name => 'Woo') }
    subject       { records }

    it { should be_empty }
  end
end
