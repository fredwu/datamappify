require 'spec_helper'

shared_examples_for "a repository" do |data_provider|
  let(:namespace)       { "Datamappify::Data::Record::#{data_provider}".constantize }
  let(:user_repository) { "UserRepository#{data_provider}".constantize.instance }

  context "#{data_provider}" do
    it "defines the data class" do
      user_repository.data_mapper.default_source_class
      namespace.const_defined?(:User, false).should == true
    end

    describe "delegation" do
      subject { "UserRepository#{data_provider}".constantize }

      it "delegates methods to the instance singleton" do
        expect { subject.find(1) }.to_not raise_error
      end

      describe "catch-all delegation" do
        before do
          user_repository.class_eval do
            attr_reader :dummy_method
          end
        end

        it "delegates other methods to the instance singleton" do
          expect { subject.dummy_method }.to_not raise_error
        end
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "a repository", data_provider
  end
end
