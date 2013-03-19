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

  describe "#find" do
    describe "resource" do
      let!(:user) { user_repository.save(existing_user) }

      it "found" do
        user_repository.find(user.id).should == existing_user
        user_repository.find([user.id]).should == [existing_user]
      end

      it "not found" do
        user_repository.find(42).should == nil
      end
    end

    describe "collection" do
      let!(:user) { user_repository.save(existing_user) }

      it "found" do
        user_repository.find([user.id]).should == [existing_user]
      end

      it "partial found" do
        user_repository.find([user.id, 42]).should == [existing_user]
      end

      it "not found" do
        user_repository.find([42, 255]).should == []
      end
    end
  end

  describe "#save" do
    it "success" do
      new_user = nil

      expect { new_user = user_repository.save(new_valid_user) }.to change { user_repository.count }.by(1)

      new_user.should be_kind_of(User)
      new_user.first_name.should == 'Batman'
      new_user.driver_license.should == 'ARKHAMCITY'
    end

    it "failure" do
      -> { user_repository.save!(new_invalid_user) }.should raise_error(Datamappify::Data::EntityNotSaved)
    end

    it "transaction" do
      new_valid_user.passport = 'DEVOPS'

      save_action = Proc.new { -> { user_repository.save(new_valid_user) }.should raise_error }

      expect { save_action.call }.to change { user_repository.count }.by(0)
      expect { save_action.call }.to change { data_passports.count }.by(0)
      expect { save_action.call }.to change { data_driver_licenses.count }.by(0)
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
        user = user_repository.save(existing_user)

        user.first_name = 'Vivian'
        user.driver_license = 'LOCOMOTE'

        updated_user = nil

        expect { updated_user = user_repository.save(user) }.to change { user_repository.count }.by(0)

        updated_user.first_name.should == 'Vivian'
        updated_user.driver_license.should == 'LOCOMOTE'

        persisted_user = user_repository.find(updated_user.id)

        persisted_user.first_name.should == 'Vivian'
        persisted_user.driver_license.should == 'LOCOMOTE'
      end

      it "updates existing and new records" do
        user = user_repository.save(existing_user)

        user.first_name = 'Vivian'
        user.health_care = 'BATMANCAVE'

        updated_user = nil

        expect { updated_user = user_repository.save(user) }.to change { user_repository.count }.by(0)

        updated_user.first_name.should == 'Vivian'
        updated_user.health_care.should == 'BATMANCAVE'

        persisted_user = user_repository.find(updated_user.id)

        persisted_user.first_name.should == 'Vivian'
        persisted_user.health_care.should == 'BATMANCAVE'
      end
    end
  end

  describe "#destroy" do
    describe "resource" do
      let!(:user) { user_repository.save(new_valid_user) }

      it "via id" do
        expect { user_repository.destroy!(user.id) }.to change { user_repository.count }.by(-1)
      end

      it "via entity" do
        expect { user_repository.destroy!(user) }.to change { user_repository.count }.by(-1)
      end
    end

    describe "collection" do
      let!(:users) { user_repository.save([new_valid_user, new_valid_user2]) }

      it "via id" do
        expect { user_repository.destroy!(users.map(&:id)) }.to change { user_repository.count }.by(-2)
      end

      it "via entity" do
        expect { user_repository.destroy!(users) }.to change { user_repository.count }.by(-2)
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "repository persistence", data_provider
  end

  describe "entity composed from multiple data providers" do
    let!(:hero_repository) { HeroUserRepository.instance }
    let!(:hero)            { HeroUser.new :first_name => 'Aaron', :last_name => 'Patterson' }

    it "#find" do
      saved_hero = nil

      expect { saved_hero = hero_repository.save!(hero) }.to change { hero_repository.count }.by(1)

      saved_hero.first_name.should == 'Aaron'
      saved_hero.last_name.should == 'Patterson'
      saved_hero.nickname = 'unsaved nickname'

      persisted_hero = hero_repository.find(saved_hero.id)
      persisted_hero.first_name.should == 'Aaron'
      persisted_hero.last_name.should == 'Patterson'
      persisted_hero.nickname.should be_nil
    end
  end
end
