require 'spec_helper'

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
      let(:create_method) { Datamappify::Repository::QueryMethod::Create }
      let(:update_method) { Datamappify::Repository::QueryMethod::Update }

      it "does not perform when there are no dirty attributes" do
        Datamappify::Logger.should_not_receive(:performed).with(update_method)

        user_repository.save(existing_user)
      end

      it "performs when there are dirty attributes" do
        Datamappify::Logger.should_receive(:performed).with(update_method).once

        existing_user.first_name = 'Dirty'
        user_repository.save(existing_user)
      end

      it "performs when the entity is new" do
        Datamappify::Logger.should_receive(:performed).with(create_method).at_least(:twice)

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
