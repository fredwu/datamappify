require 'spec_helper'

shared_examples_for "finder find" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    describe "#find" do
      describe "by id" do
        subject { user_repository.find(existing_user.id) }

        its(:id) { should == existing_user.id }
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finder find", data_provider
  end
end
