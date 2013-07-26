require 'spec_helper'

shared_examples_for "finder all" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    describe "#all" do
      let(:records) { user_repository.all }
      subject       { records }

      it { should have(3).users }

      its(:first) { should == existing_user }
      its(:last)  { should == existing_user_2 }

      describe "record" do
        subject { records.first }

        its(:first_name) { should == existing_user.first_name }
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finder all", data_provider
  end
end
