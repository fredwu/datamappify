require_relative 'spec_helper'

shared_examples_for "a repository" do |data_provider|
  let(:data_provider_module) { "Datamappify::Data::#{data_provider}".constantize }
  let!(:user_repository)     { "UserRepository#{data_provider}".constantize.instance }
  subject                    { data_provider_module }

  it "defines the data class after the repository is initialised" do
    subject.const_defined?(:User, false).should == true
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "a repository", data_provider
  end
end
