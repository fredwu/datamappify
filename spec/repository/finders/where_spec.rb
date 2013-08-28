require 'spec_helper'

shared_examples_for "finder where" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    describe "#where" do
      include_context "where or match context"
      it_behaves_like "where or match finder", :where, data_provider
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finder where", data_provider
  end
end
