require_relative '../spec_helper'

shared_examples_for "transactions" do |data_provider|
  include_context "user repository", data_provider

  context "#{data_provider}" do
    describe "#save" do
      it "raises error upon transaction failure" do
        new_valid_user.passport = 'DEVOPS'

        save_action = Proc.new { -> { user_repository.save(new_valid_user) }.should raise_error }

        expect { save_action.call }.to change { user_repository.count }.by(0)
        expect { save_action.call }.to change { data_passports.count }.by(0)
        expect { save_action.call }.to change { data_driver_licenses.count }.by(0)
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "transactions", data_provider
  end
end
