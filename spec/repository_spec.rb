require_relative 'spec_helper'

shared_examples_for "a repository" do |data_provider|
  let(:namespace)       { "Datamappify::Data::Record::#{data_provider}".constantize }
  let(:user_repository) { "UserRepository#{data_provider}".constantize.instance }

  it "defines the data class" do
    user_repository.data_mapper.default_source_class
    namespace.const_defined?(:User, false).should == true
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "a repository", data_provider
  end
end
