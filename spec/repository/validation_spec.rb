require 'spec_helper'

shared_examples_for "repository (in)validation" do |data_provider|
  include_context "user repository", data_provider

  context "#{data_provider}" do
    describe "invalid" do
      let(:invalid_user) { User.new(:first_name => 'F') }

      after do
        invalid_user.id.should be_nil
      end

      it "makes sure the entity is invalid" do
        invalid_user.valid?.should == false
      end

      it "doesn't persist the entity" do
        user_repository.save(invalid_user).should == false
      end
    end

    describe "valid" do
      let(:valid_user) { User.new(:first_name => 'Fred', :driver_license => 'MOSDEVOPS') }

      it "makes sure the entity is invalid" do
        valid_user.valid?.should == true
      end

      it "does persist the entity" do
        user_repository.save(valid_user).should be_kind_of(User)
        valid_user.id.should be_kind_of(Integer)
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "repository (in)validation", data_provider
  end
end
