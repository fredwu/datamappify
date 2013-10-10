require 'spec_helper'

shared_examples_for "has_one records" do
  subject { saved_group }

  its(:name)   { should == 'People' }
  its(:leader) { should be_kind_of(SuperUser) }

  context "leader" do
    subject { saved_group.leader }

    its(:id)             { should == existing_user.id }
    its(:first_name)     { should == 'Steve' }
    its(:driver_license) { should == 'APPLECOMPUTER' }
    its(:group_id)       { should == saved_group.id }
  end
end

shared_examples_for "has_one new records created from nested form attributes" do
  let(:group) do
    Group.new(
      :name              => 'People',
      :leader_attributes => {
        'first_name' => 'Bill', 'driver_license' => 'NEXTCOMPUTER',  'id' => ''
      }
    )
  end

  subject { saved_group.leader }

  its(:id)             { should_not be_nil }
  its(:id)             { should_not == existing_user.id }
  its(:first_name)     { should == 'Bill' }
  its(:driver_license) { should == 'NEXTCOMPUTER' }
  its(:group_id)       { should == saved_group.id }
end

shared_examples_for "has_one records created from nested form attributes" do
  let(:group) do
    Group.new(
      :name              => 'People',
      :leader            => existing_user,
      :leader_attributes => {
        'first_name' => 'Bill', 'driver_license' => 'NEXTCOMPUTER'
      }
    )
  end

  subject { saved_group.leader }

  its(:id)             { should == existing_user.id }
  its(:first_name)     { should == 'Bill' }
  its(:driver_license) { should == 'NEXTCOMPUTER' }
  its(:group_id)       { should == saved_group.id }
end

shared_examples_for "has_one records from nested form attributes with invalid data" do
  let(:group) do
    Group.new(
      :name   => 'People',
      :leader => existing_user
    )
  end

  let(:new_group) do
    Group.new(
      :id                => saved_group.id,
      :name              => 'New People',
      :leader            => existing_user,
      :leader_attributes => {
        'first_name' => 'Bill', 'driver_license' => 'JEFF'
      }
    )
  end

  context "non-saved dirty new group" do
    subject { new_group }

    its(:name)   { should == 'New People' }
    its(:leader) { should be_kind_of(SuperUser) }
    its(:valid?) { should be_false }

    it "does not save" do
      -> { group_repository.save!(new_group) }.should raise_error(Datamappify::Data::EntityNotSaved)
    end
  end

  context "fresh copy of the non-saved new group" do
    before do
      group_repository.save(new_group)
    end

    subject { group_repository.find(new_group.id) }

    its(:name)   { should == 'People' }
    its(:leader) { should be_kind_of(SuperUser) }
    its(:valid?) { should be_true }
  end
end

shared_examples_for "has_one records destroy from nested form attributes" do
  let(:group) do
    Group.new(
      :name              => 'People',
      :leader            => existing_user,
      :leader_attributes => {
        'id' => existing_user.id.to_s, 'first_name' => 'Jeff', 'driver_license' => 'NEXTCOMPUTER', '_destroy' => '1'
      }
    )
  end

  subject { saved_group }

  its(:leader) { should be_nil }
end

shared_examples_for "has_one data records" do |data_provider|
  let(:data_groups)               { "Datamappify::Data::Record::#{data_provider}::Group".constantize }
  let(:data_super_user)           { "Datamappify::Data::Record::#{data_provider}::SuperUser".constantize }
  let(:data_user)                 { "Datamappify::Data::Record::#{data_provider}::User".constantize }
  let(:data_user_driver_licenses) { "Datamappify::Data::Record::#{data_provider}::UserDriverLicense".constantize }

  before do
    saved_group
  end

  describe "data records" do
    it "does not create extra primary data records" do
      expect { saved_group }.to change { data_groups.count }.by(0)
    end

    it "does not create extra associated primary data records" do
      expect { saved_group }.to change { data_super_user.count }.by(0)
    end

    it "does not create extra associated secondary data records" do
      expect { saved_group }.to change { data_user.count }.by(0)
    end

    it "does not create extra secondary data records" do
      expect { saved_group }.to change { data_user_driver_licenses.count }.by(0)
    end
  end
end

shared_examples_for "has_one" do |data_provider|
  let(:user_repository)  { "SuperUserRepository#{data_provider}".constantize }
  let(:group_repository) { "GroupRepository#{data_provider}".constantize }
  let(:new_user)         { SuperUser.new(:first_name => 'Fred', :driver_license => 'MOSDEVOPS') }
  let(:existing_user)    { user_repository.save! SuperUser.new(:first_name => 'Steve', :driver_license => 'APPLECOMPUTER') }
  let(:existing_user_2)  { user_repository.save! SuperUser.new(:first_name => 'Bill', :driver_license => 'MICROCOMPUTER') }
  let(:group) do
    Group.new(
      :name   => 'People',
      :leader => existing_user
    )
  end

  it "existing_user" do
    existing_user.id.should_not be_nil
  end

  describe "group entity" do
    subject { group }

    its(:leader) { should be_kind_of(SuperUser) }
  end

  context "#{data_provider}" do
    context "immediate return" do
      let(:saved_group) { group_repository.save!(group) }

      it_behaves_like "has_one records"
      it_behaves_like "has_one new records created from nested form attributes"
      it_behaves_like "has_one records created from nested form attributes"
      it_behaves_like "has_one records from nested form attributes with invalid data"
      it_behaves_like "has_one data records", data_provider
    end

    context "reloaded return" do
      let(:saved_group) { group_repository.save!(group); group_repository.find(group.id) }

      it_behaves_like "has_one records"
      it_behaves_like "has_one new records created from nested form attributes"
      it_behaves_like "has_one records created from nested form attributes"
      it_behaves_like "has_one records from nested form attributes with invalid data"
      it_behaves_like "has_one records destroy from nested form attributes"
      it_behaves_like "has_one data records", data_provider
    end

    context "collection return" do
      let(:saved_group) { group_repository.save!(group); group_repository.all.detect { |g| g.id == group.id } }

      it_behaves_like "has_one records"
      it_behaves_like "has_one new records created from nested form attributes"
      it_behaves_like "has_one records created from nested form attributes"
      it_behaves_like "has_one records from nested form attributes with invalid data"
      it_behaves_like "has_one records destroy from nested form attributes"
      it_behaves_like "has_one data records", data_provider
    end

    context "criteria return" do
      let(:saved_group) { group_repository.save!(group); group_repository.criteria(:where => { :id => group.id }).first }

      it_behaves_like "has_one records"
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "has_one", data_provider
  end
end
