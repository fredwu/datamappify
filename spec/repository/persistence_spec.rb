require 'spec_helper'

shared_examples_for "repository persistence" do |data_provider|
  include_context "user repository", data_provider

  context "#{data_provider}" do
    describe "#find" do
      it "found" do
        user_repository.find(existing_user.id).should == existing_user
      end

      it "not found" do
        user_repository.find(233).should == nil
      end
    end

    [:create, :create!, :update, :update!, :save, :save!].each do |query_method|
      let(:query_method) { query_method }

      describe "##{query_method}" do
        it "success" do
          new_user = nil

          expect { new_user = user_repository.send(query_method, new_valid_user) }.to change { user_repository.count }.by(1)

          new_user.should be_kind_of(User)
          new_user.first_name.should == 'Batman'
          new_user.driver_license.should == 'ARKHAMCITY'
          new_user.persisted?.should == true
        end

        it "failure" do
          -> { user_repository.save!(new_invalid_user) }.should raise_error(Datamappify::Data::EntityNotSaved)
          new_invalid_user.persisted?.should == false
        end

        it "updates existing records" do
          existing_user.first_name = 'Vivian'
          existing_user.driver_license = 'LOCOMOTE'

          updated_user = nil

          expect { updated_user = user_repository.send(query_method, existing_user) }.to change { user_repository.count }.by(0)

          updated_user.first_name.should == 'Vivian'
          updated_user.driver_license.should == 'LOCOMOTE'

          persisted_user = user_repository.find(updated_user.id)

          persisted_user.first_name.should == 'Vivian'
          persisted_user.driver_license.should == 'LOCOMOTE'
          persisted_user.persisted?.should == true
        end

        it "updates existing records with nils" do
          existing_user.last_name = nil
          existing_user.health_care = nil

          updated_user = nil

          expect { updated_user = user_repository.send(query_method, existing_user) }.to change { user_repository.count }.by(0)

          updated_user.last_name.should == nil
          updated_user.health_care.should == nil

          persisted_user = user_repository.find(updated_user.id)

          persisted_user.last_name.should == nil
          persisted_user.health_care.should == nil
          persisted_user.persisted?.should == true
        end

        it "updates existing and new records" do
          existing_user.first_name = 'Vivian'
          existing_user.health_care = 'BATMANCAVE'

          updated_user = nil

          expect { updated_user = user_repository.send(query_method, existing_user) }.to change { user_repository.count }.by(0)

          updated_user.first_name.should == 'Vivian'
          updated_user.health_care.should == 'BATMANCAVE'

          persisted_user = user_repository.find(updated_user.id)

          persisted_user.first_name.should == 'Vivian'
          persisted_user.health_care.should == 'BATMANCAVE'
          persisted_user.persisted?.should == true
        end
      end
    end

    describe "#destroy" do
      let!(:user) { user_repository.save(new_valid_user) }

      it "destroys an entity" do
        expect { user_repository.destroy!(user) }.to change { user_repository.count }.by(-1)
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "repository persistence", data_provider
  end

  describe "entity composed from multiple data providers" do
    let!(:hero_repository) { HeroUserRepository }
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
