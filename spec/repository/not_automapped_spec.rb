require 'spec_helper'

shared_examples_for "not automapped" do |data_provider|
  let!(:dumb_user_repository) { "Dumb::UserRepository#{data_provider}".constantize }
  let(:new_user)              { Dumb::User.new(:first_name => 'Fred', :last_name => 'Wu', :health_care => 'DONTPERSISTME') }

  context "#{data_provider}" do

    describe "persistence" do
      before do
        dumb_user_repository.save!(new_user)
      end

      describe "persisted attributes" do
        subject { dumb_user_repository.save!(new_user) }

        its(:id)          { should_not be_nil }
        its(:first_name)  { should == 'Fred' }
        its(:last_name)   { should == 'Wu' }
        its(:health_care) { should == 'DONTPERSISTME' }
      end

      describe "finding" do
        let!(:another_user) { Dumb::User.new(:first_name => "Benny", :last_name => "Boy", :health_care => 'DONTPERSISTME') }

        let!(:saved_user) { dumb_user_repository.save!(another_user) }

        subject { dumb_user_repository.find(saved_user.id) }

        its(:id)          { should_not be_nil }
        its(:first_name)  { should == 'Benny' }
        its(:last_name)   { should == 'Boy' }
        its(:health_care) { should be_nil }
      end

    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "not automapped", data_provider
  end
end

