require 'spec_helper'

shared_examples_for "finders" do |data_provider|
  include_context "user repository", data_provider

  let!(:existing_user_1) { user_repository.save(new_valid_user.dup) }
  let!(:existing_user_2) { user_repository.save(new_valid_user.dup) }

  context "#{data_provider}" do
    describe "#all" do
      it "finds all entities in a repository" do
        user_repository.all.should have(3).users
      end

      it "finds first entity" do
        user_repository.all.first.should == existing_user
      end

      it "finds last entity" do
        user_repository.all.last.should == existing_user_2
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finders", data_provider
  end
end
