require 'spec_helper'

shared_examples_for "has_many records" do
  its(:name)  { should == 'People' }
  its(:users) { should have(2).items }

  context "existing user" do
    subject { saved_group.users.first }

    its(:id)             { should == existing_user.id }
    its(:first_name)     { should == 'Steve' }
    its(:driver_license) { should == 'APPLECOMPUTER' }
    its(:group_id)       { should == saved_group.id }
  end

  context "new user" do
    subject { saved_group.users.last }

    its(:id)             { should_not be_nil }
    its(:first_name)     { should == 'Fred' }
    its(:driver_license) { should == 'MOSDEVOPS' }
    its(:group_id)       { should == saved_group.id }
  end
end

shared_examples_for "has_many" do |data_provider|
  let(:user_repository)  { "UserRepository#{data_provider}".constantize }
  let(:group_repository) { "GroupRepository#{data_provider}".constantize }
  let(:new_user)      { User.new(:first_name => 'Fred', :driver_license => 'MOSDEVOPS') }
  let(:existing_user) { user_repository.save! User.new(:first_name => 'Steve', :driver_license => 'APPLECOMPUTER') }
  let(:group) do
    Group.new(
      :name  => 'People',
      :users => [existing_user, new_user]
    )
  end

  describe "group entity" do
    subject { group }

    its(:users) { should have(2).items }
  end

  context "#{data_provider}" do
    context "immediate return" do
      let(:saved_group) { group_repository.save!(group) }
      subject           { saved_group }

      it_behaves_like "has_many records"
    end

    context "reloaded return" do
      let(:saved_group) { group_repository.save!(group); group_repository.find(group.id) }
      subject           { saved_group }

      it_behaves_like "has_many records"
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "has_many", data_provider
  end
end
