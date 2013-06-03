require 'spec_helper'

shared_examples_for "entity inheritance" do |data_provider|
  context "#{data_provider}" do
    let!(:admin_user_repository) { "AdminUserRepository#{data_provider}".constantize }
    let(:admin_user)             { admin_user_repository.save!(AdminUser.new(:first_name => 'Batman', :driver_license => 'ARKHAMCITY', :level => 42)) }

    describe "persistence" do
      subject { admin_user }

      it_behaves_like "entity inheritance attributes"
    end

    describe "finder" do
      subject { admin_user_repository.find(admin_user.id) }

      it_behaves_like "entity inheritance attributes"
    end
  end
end

shared_examples_for "entity inheritance attributes" do
  its(:id)             { should be_kind_of(Integer) }
  its(:first_name)     { should == 'Batman' }
  its(:driver_license) { should == 'ARKHAMCITY' }
  its(:level)          { should == 42 }
end

describe Datamappify::Entity do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "entity inheritance", data_provider
  end
end
