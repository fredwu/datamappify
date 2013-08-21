require 'spec_helper'

shared_examples_for "has_many records" do
  subject { saved_group }

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

shared_examples_for "has_many records created from nested form attributes" do
  let(:group) do
    Group.new(
      :name             => 'People',
      :users            => [existing_user],
      :users_attributes => {
        '0' => { 'first_name' => 'Bill', 'driver_license' => 'NEXTCOMPUTER' },
        '1' => { 'first_name' => 'Alan', 'driver_license' => 'MICROCOMPUTER', 'id' => existing_user.id.to_s },
        '2' => { 'first_name' => 'Jeff', 'driver_license' => 'JEFFCOMPUTER' },
      }
    )
  end

  subject { saved_group }

  its(:users) { should have(3).items }

  context "replaced user" do
    subject { saved_group.users.first }

    its(:id)             { should_not be_nil }
    its(:first_name)     { should == 'Alan' }
    its(:driver_license) { should == 'MICROCOMPUTER' }
    its(:group_id)       { should == saved_group.id }
  end

  context "created user 1" do
    subject { saved_group.users[1] }

    its(:id)             { should_not be_nil }
    its(:first_name)     { should == 'Bill' }
    its(:driver_license) { should == 'NEXTCOMPUTER' }
    its(:group_id)       { should == saved_group.id }
  end

  context "created user 2" do
    subject { saved_group.users[2] }

    its(:id)             { should_not be_nil }
    its(:first_name)     { should == 'Jeff' }
    its(:driver_license) { should == 'JEFFCOMPUTER' }
    its(:group_id)       { should == saved_group.id }
  end
end

shared_examples_for "has_many" do |data_provider|
  let(:user_repository)  { "SuperUserRepository#{data_provider}".constantize }
  let(:group_repository) { "GroupRepository#{data_provider}".constantize }
  let(:new_user)         { SuperUser.new(:first_name => 'Fred', :driver_license => 'MOSDEVOPS') }
  let(:existing_user)    { user_repository.save! SuperUser.new(:first_name => 'Steve', :driver_license => 'APPLECOMPUTER') }
  let(:group) do
    Group.new(
      :name  => 'People',
      :users => [existing_user, new_user]
    )
  end

  it "existing_user" do
    existing_user.id.should_not be_nil
  end

  describe "group entity" do
    subject { group }

    its(:users) { should have(2).items }
  end

  context "#{data_provider}" do
    context "immediate return" do
      let(:saved_group) { group_repository.save!(group) }

      it_behaves_like "has_many records"
      it_behaves_like "has_many records created from nested form attributes"
    end

    context "reloaded return" do
      let(:saved_group) { group_repository.save!(group); group_repository.find(group.id) }

      it_behaves_like "has_many records"
      it_behaves_like "has_many records created from nested form attributes"
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "has_many", data_provider
  end
end
