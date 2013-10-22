require 'spec_helper'

shared_examples_for "extensions - Kaminari" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    describe "pagination" do
      let(:records) { user_repository.criteria(page: 2, per: 1) }
      subject       { records }

      it { should have(1).user }

      its(:current_page) { should == 2 }
      its(:limit_value)  { should == 1 }
      its(:offset_value) { should == 1 }
      its(:total_count)  { should == 3 }

      its(:first) { should == existing_user_1 }
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "extensions - Kaminari", data_provider
  end
end
