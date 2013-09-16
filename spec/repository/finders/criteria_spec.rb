require 'spec_helper'

shared_examples_for "finders examples" do |data_provider|
  [
    { :where => { :last_name => 'Superman' }, :limit => 2, :order => { :last_name => :asc, :first_name => :desc, :id => :desc } },
    { :order => { :last_name => :asc, :first_name => :desc, :id => :desc }, :limit => 2, :where => { :last_name => 'Superman' } },
    { :where => {}, :match => { :last_name => 'Super%' }, :limit => 2, :order => { :last_name => :asc, :first_name => :desc, :id => :desc } }
  ].each_with_index do |criteria, index|
    describe "#criteria example #{index+1}" do
      let(:records) { user_repository.criteria(criteria) }
      subject       { records }

      it { should have(2).user }

      context "record" do
        subject { records.first }

        its(:first_name) { should == 'CC' }
      end
    end
  end
end

shared_examples_for "user finders" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    before do
      user_repository.save!(User.new(:last_name => 'Batman', :first_name => 'AA', :driver_license => 'ARKHAMCITY'))
      user_repository.save!(User.new(:last_name => 'Ironman', :first_name => 'AA', :driver_license => 'NEWYORKCITY'))
      user_repository.save!(User.new(:last_name => 'Superman', :first_name => 'AA', :driver_license => 'MELBOURNE'))
      user_repository.save!(User.new(:last_name => 'Superman', :first_name => 'BB', :driver_license => 'SHANGHAI'))
      user_repository.save!(User.new(:last_name => 'Superman', :first_name => 'CC', :driver_license => 'NEWYORKCITY'))
    end

    it_behaves_like "finders examples", data_provider
  end
end

shared_examples_for "super user finders" do |data_provider|
  let(:user_repository) { "SuperUserRepository#{data_provider}".constantize }

  context "#{data_provider}" do
    before do
      user_repository.save!(SuperUser.new(:last_name => 'Batman', :first_name => 'AA', :driver_license => 'ARKHAMCITY'))
      user_repository.save!(SuperUser.new(:last_name => 'Ironman', :first_name => 'AA', :driver_license => 'NEWYORKCITY'))
      user_repository.save!(SuperUser.new(:last_name => 'Superman', :first_name => 'AA', :driver_license => 'MELBOURNE'))
      user_repository.save!(SuperUser.new(:last_name => 'Superman', :first_name => 'BB', :driver_license => 'SHANGHAI'))
      user_repository.save!(SuperUser.new(:last_name => 'Superman', :first_name => 'CC', :driver_license => 'NEWYORKCITY'))
    end

    it_behaves_like "finders examples", data_provider
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "user finders", data_provider
    it_behaves_like "super user finders", data_provider
  end
end
