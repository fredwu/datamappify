require_relative '../spec_helper'

shared_examples_for "dirty persistence" do |data_provider|
  include_context "user repository", data_provider

  context "#{data_provider}" do
    describe "#find" do
      it "finds a persisted entity" do
        persisted_user = user_repository.find(existing_user.id)
        persisted_user.first_name.should == existing_user.first_name
      end
    end

    describe "#save" do
      it "does not perform when there are no dirty attributes" do
        Datamappify::Repository::QueryMethod::Save.should_not_receive(:performed)

        user_repository.save(existing_user)
      end

      it "performs when there are dirty attributes" do
        Datamappify::Repository::QueryMethod::Save.should_receive(:performed).once

        existing_user.first_name = 'Dirty'
        user_repository.save(existing_user)
      end

      it "performs when the entity is new" do
        Datamappify::Repository::QueryMethod::Save.should_receive(:performed).at_least(:twice)

        user_repository.save(new_valid_user)
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "dirty persistence", data_provider
  end
end
