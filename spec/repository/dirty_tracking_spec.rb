require 'spec_helper'

shared_examples_for "dirty tracking" do |data_provider|
  include_context "user repository", data_provider

  context "#{data_provider}" do
    describe 'entity attributes' do
      after do
        user_repository.save(existing_user)
        user_repository.states.find(existing_user).changed?.should == false
        user_repository.states.find(existing_user).changes.should be_empty
      end

      it "clean slate" do
        user_repository.states.find(existing_user).first_name_changed?.should == false
      end

      describe "change by assignment" do
        it "changed" do
          existing_user.first_name = 'ChangedName'
          state = user_repository.states.find(existing_user)

          state.first_name_changed?.should == true
          state.last_name_changed?.should == false
          state.changes.should == { 'first_name' => %w{Fred ChangedName} }
        end

        it "unchanged" do
          first_name = existing_user.first_name
          existing_user.first_name = 'ChangedName'
          existing_user.first_name = first_name
          state = user_repository.states.find(existing_user)

          state.first_name_changed?.should == false
          state.last_name_changed?.should == false
          state.changes.should be_empty
        end
      end

      describe "change by mutation" do

        it "changed" do
          existing_user.first_name << 'APPEND'
          state = user_repository.states.find(existing_user)

          state.first_name_changed?.should == true
          state.last_name_changed?.should == false
          state.changes.should == { 'first_name' => %w{Fred FredAPPEND} }
        end

        it "unchanged" do
          first_name = existing_user.first_name.dup
          existing_user.first_name << 'APPEND'
          existing_user.first_name = first_name
          state = user_repository.states.find(existing_user)

          state.first_name_changed?.should == false
          state.last_name_changed?.should == false
          state.changes.should be_empty
        end
      end
    end

    describe "manually mark as dirty" do
      it "marks an entity as dirty" do
        user_repository.states.mark_as_dirty(existing_user)
        state = user_repository.states.find(existing_user)

        state.changed?.should == true
        state.first_name_changed?.should == true
        state.last_name_changed?.should == true
        state.age_changed?.should == true
        state.changes.keys.should include('first_name')
        state.changes.keys.should include('last_name')
        state.changes.keys.should include('age')
      end

      it "marks entity attributes as dirty" do
        user_repository.states.mark_as_dirty(existing_user, :first_name, :age)
        state = user_repository.states.find(existing_user)

        state.changed?.should == true
        state.first_name_changed?.should == true
        state.last_name_changed?.should == false
        state.age_changed?.should == true
        state.changes.keys.should =~ %w{first_name age}
      end
    end

    describe "default source operations" do
      let(:user) { user_repository.all.first }

      it "clean slate" do
        user_repository.states.find(user).first_name_changed?.should == false
        user_repository.states.find(user).changes.should be_empty
      end

      it "changed" do
        user.first_name = 'Nexus'
        user_repository.states.find(user).first_name_changed?.should == true
        user_repository.states.find(user).changes.should == { 'first_name' => %w{Fred Nexus} }
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "dirty tracking", data_provider
  end
end
