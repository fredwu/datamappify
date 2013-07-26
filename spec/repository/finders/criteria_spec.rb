require 'spec_helper'

shared_examples_for "finders" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    before do
      user_repository.save(User.new(:first_name => 'Batman', :driver_license => 'ARKHAMCITY'))
      user_repository.save(User.new(:first_name => 'Ironman', :driver_license => 'NEWYORKCITY'))
      user_repository.save(User.new(:first_name => 'Superman', :driver_license => 'MELBOURNE'))
      user_repository.save(User.new(:first_name => 'Superman', :driver_license => 'SHANGHAI'))
      user_repository.save(User.new(:first_name => 'Superman', :driver_license => 'NEWYORKCITY'))
    end

    describe "#criteria" do
      let(:records) { user_repository.criteria(:where => { :first_name => 'Superman' }, :limit => 2) }
      subject       { records }

      it { should have(2).user }
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finders", data_provider
  end
end
