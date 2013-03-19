require_relative '../spec_helper'

shared_examples_for "repository persistence" do |data_provider|
  let!(:user_repository)     { "UserRepository#{data_provider}".constantize.instance }
  let(:existing_user)        { User.new(:id => 1, :first_name => 'Fred', :driver_license => 'FREDWU42') }
  let(:new_valid_user)       { User.new(:first_name => 'Batman', :driver_license => 'ARKHAMCITY') }
  let(:new_valid_user2)      { User.new(:first_name => 'Ironman', :driver_license => 'NEWYORKCITY') }
  let(:new_invalid_user)     { User.new(:first_name => 'a') }
  let(:new_invalid_user2)    { User.new(:first_name => 'b') }
  let(:data_passports)       { "Datamappify::Data::#{data_provider}::UserPassport".constantize }
  let(:data_driver_licenses) { "Datamappify::Data::#{data_provider}::UserDriverLicense".constantize }

  before do
    user_repository.save(existing_user)
  end

  describe "#find" do
    describe "resource" do
      it "found" do
        user_repository.find(1).should == existing_user
        user_repository.find([1]).should == [existing_user]
      end

      it "not found" do
        user_repository.find(42).should == nil
      end
    end

    describe "collection" do
      it "found" do
        user_repository.find([1]).should == [existing_user]
      end

      it "partial found" do
        user_repository.find([1, 2]).should == [existing_user]
      end

      it "not found" do
        user_repository.find([42, 255]).should == []
      end
    end
  end

  describe "#save" do
    it "success" do
      expect { user_repository.save(new_valid_user) }.to change { user_repository.count }.by(1)

      new_user = user_repository.find(user_repository.count)
      new_user.should be_kind_of(User)
      new_user.first_name.should == 'Batman'
      new_user.driver_license.should == 'ARKHAMCITY'
    end

    it "failure" do
      -> { user_repository.save!(new_invalid_user) }.should raise_error(Datamappify::Data::EntityNotSaved)
    end

    it "transaction" do
      DatabaseCleaner.clean

      new_valid_user.passport = 'DEVOPS'

      -> { user_repository.save(new_valid_user) }.should raise_error(ActiveRecord::StatementInvalid)

      user_repository.count.should == 0
      data_passports.count.should == 0
      data_driver_licenses.count.should == 0
    end

    describe "update multiple entities" do
      describe "#save" do
        it "all successes" do
          expect { user_repository.save([new_valid_user, new_valid_user2]) }.to change { user_repository.count }.by(2)
        end

        it "successes + failures" do
          expect { user_repository.save([new_valid_user, new_invalid_user]) }.to change { user_repository.count }.by(1)
        end

        it "all failures" do
          expect { user_repository.save([new_invalid_user, new_invalid_user2]) }.to change { user_repository.count }.by(0)
        end
      end

      describe "#save!" do
        it "all successes" do
          expect { user_repository.save!([new_valid_user, new_valid_user2]) }.to change { user_repository.count }.by(2)
        end

        it "successes + failures" do
          expect { -> { user_repository.save!([new_valid_user, new_invalid_user]) }.should raise_error(Datamappify::Data::EntityNotSaved) }.to change { user_repository.count }.by(1)
        end

        it "all failures" do
          expect { -> { user_repository.save!([new_invalid_user, new_invalid_user2]) }.should raise_error(Datamappify::Data::EntityNotSaved) }.to change { user_repository.count }.by(0)
        end
      end
    end

    describe "update an existing entity" do
      it "updates existing records" do
        user = user_repository.find(1)

        user.first_name = 'Vivian'
        user.driver_license = 'LOCOMOTE'

        updated_user = user_repository.save(user)

        updated_user.first_name.should == 'Vivian'
        updated_user.driver_license.should == 'LOCOMOTE'

        persisted_user = user_repository.find(updated_user.id)

        persisted_user.first_name.should == 'Vivian'
        persisted_user.driver_license.should == 'LOCOMOTE'

        user_repository.count.should == 1
      end

      it "updates existing and new records" do
        user = user_repository.find(1)

        user.first_name = 'Vivian'
        user.health_care = 'BATMANCAVE'

        updated_user = user_repository.save(user)

        updated_user.first_name.should == 'Vivian'
        updated_user.health_care.should == 'BATMANCAVE'

        persisted_user = user_repository.find(updated_user.id)

        persisted_user.first_name.should == 'Vivian'
        persisted_user.health_care.should == 'BATMANCAVE'

        user_repository.count.should == 1
      end
    end
  end

  describe "#destroy" do
    describe "resource" do
      it "via id" do
        user_repository.destroy!(1)
        user_repository.count.should == 0
      end

      it "via entity" do
        user = user_repository.find(1)

        user_repository.destroy!(user)
        user_repository.count.should == 0
      end
    end

    describe "collection" do
      before do
        user_repository.save(new_valid_user)
      end

      it "via id" do
        user_repository.destroy!([1, 2])
        user_repository.count.should == 0
      end

      it "via entity" do
        users = user_repository.find([1, 2])

        user_repository.destroy!(users)
        user_repository.count.should == 0
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "repository persistence", data_provider
  end
end
