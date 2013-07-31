require 'spec_helper'

shared_examples_for "dirty tracking" do |data_provider|
  include_context "user repository", data_provider

  context "#{data_provider}" do
    describe "entity attribute (simple)" do
      after do
        user_repository.save(existing_user)
        user_repository.states.find(existing_user).first_name_changed?.should == false
      end

      it "clean slate" do
        user_repository.states.find(existing_user).first_name_changed?.should == false
      end

      it "changed" do
        existing_user.first_name = 'ChangedName'
        user_repository.states.find(existing_user).first_name_changed?.should == true
        user_repository.states.find(existing_user).last_name_changed?.should == false
      end

      it "not changed" do
        first_name = existing_user.first_name
        existing_user.first_name = 'ChangedName'
        existing_user.first_name = first_name
        user_repository.states.find(existing_user).first_name_changed?.should == false
        user_repository.states.find(existing_user).last_name_changed?.should == false
      end
    end

    describe "entity attribute (complex)" do
      after do
        user_repository.save(existing_user)
        user_repository.states.find(existing_user).first_name_changed?.should == false
      end

      it "changed" do
        existing_user.first_name << 'super'
        user_repository.states.find(existing_user).first_name_changed?.should == true
        user_repository.states.find(existing_user).last_name_changed?.should == false
      end

      it "not changed" do
        first_name = existing_user.first_name.dup
        existing_user.first_name << 'super'
        existing_user.first_name = first_name
        user_repository.states.find(existing_user).first_name_changed?.should == false
        user_repository.states.find(existing_user).last_name_changed?.should == false
      end
    end

    describe "entity" do
      after do
        user_repository.save(existing_user)
        user_repository.states.find(existing_user).changed?.should == false
      end

      it "clean slate" do
        user_repository.states.find(existing_user).changed?.should == false
      end

      it "changed" do
        existing_user.first_name = 'ChangedName'
        user_repository.states.find(existing_user).changed?.should == true
      end

      it "not changed" do
        first_name = existing_user.first_name
        existing_user.first_name = 'ChangedName'
        existing_user.first_name = first_name
        user_repository.states.find(existing_user).changed?.should == false
      end
    end

    describe "manually mark as dirty" do
      it "marks an entity as dirty" do
        user_repository.states.mark_as_dirty(existing_user)
        user_repository.states.find(existing_user).changed?.should == true
        user_repository.states.find(existing_user).first_name_changed?.should == true
        user_repository.states.find(existing_user).last_name_changed?.should == true
        user_repository.states.find(existing_user).age_changed?.should == true
      end

      it "marks entity attributes as dirty" do
        user_repository.states.mark_as_dirty(existing_user, :first_name, :age)
        user_repository.states.find(existing_user).changed?.should == true
        user_repository.states.find(existing_user).first_name_changed?.should == true
        user_repository.states.find(existing_user).last_name_changed?.should == false
        user_repository.states.find(existing_user).age_changed?.should == true
      end
    end

    describe "default source operations" do
      let(:user) { user_repository.all.first }

      it "clean slate" do
        user_repository.states.find(user).first_name_changed?.should == false
      end

      it "changed" do
        user.first_name = 'Nexus'
        user_repository.states.find(user).first_name_changed?.should == true
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "dirty tracking", data_provider
  end
end
