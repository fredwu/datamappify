require 'spec_helper'

describe Datamappify::Lazy do
  let!(:user_repository) { HeroUserRepository }
  let!(:existing_user)   { user_repository.save(HeroUser.new(:first_name => 'Fred', :last_name => 'Wu', :gender => 'm')) }
  let(:user)             { user_repository.find(existing_user.id) }

  it "eager loads default attributes" do
    Datamappify::Logger.should_not_receive(:performed).with(:override_attribute, :last_name)
    Datamappify::Logger.should_not_receive(:performed).with(:override_attribute, :gender)

    user.id.should == 1
    user.first_name.should == 'Fred'
  end

  describe "loader" do
    before do
      Datamappify::Logger.should_receive(:performed).with(:override_attribute, :last_name).once
      Datamappify::Logger.should_not_receive(:performed).with(:override_attribute, :gender)
    end

    it "loads lazy attribute" do
      user.last_name.should == 'Wu'
    end

    it "loads lazy attribute with eager attribute" do
      user.first_name.should == 'Fred'
      user.last_name.should == 'Wu'
    end

    it "loads lazy attribute twice with eager attribute" do
      user.first_name.should == 'Fred'
      user.last_name.should == 'Wu'
      user.last_name.should == 'Wu'
    end

    it "loads lazy attributes from the same source" do
      user.first_name.should == 'Fred'
      user.last_name.should == 'Wu'
      user.gender.should == 'm'
    end
  end

  describe "simple setter" do
    before do
      Datamappify::Logger.should_not_receive(:performed).with(:override_attribute, :last_name)
    end

    it "doesn't need lazy loading when the attribute is being set" do
      user.first_name.should == 'Fred'
      user.last_name = 'Cooper'
      user.last_name.should == 'Cooper'
    end

    it "loads only the non-set attribute" do
      Datamappify::Logger.should_receive(:performed).with(:override_attribute, :gender).once

      user.first_name.should == 'Fred'
      user.last_name = 'Cooper'
      user.last_name.should == 'Cooper'
      user.gender.should == 'm'
    end
  end

  describe "complex setter" do
    it "handles complex values" do
      user.first_name.should == 'Fred'
      user.last_name << 'Cooper'
      user.last_name.should == 'WuCooper'
    end
  end
end
