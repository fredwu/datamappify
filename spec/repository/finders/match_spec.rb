require 'spec_helper'

shared_examples_for "finder match" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    describe "#match" do
      context "case sensitive" do
        include_context "where or match context"
        it_behaves_like "where or match finder", :match, data_provider
      end

      context "case insensitive" do
        let(:bob)        { 'bob' }
        let(:license)    { 'yeslicense' }
        let(:no_license) { 'No_License' }

        it_behaves_like "where or match finder", :match, data_provider
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finder match", data_provider
  end
end
