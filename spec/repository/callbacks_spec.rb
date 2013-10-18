require 'spec_helper'

shared_examples_for "callbacks" do |query_method, *performed_callbacks|
  subject { HeroUserRepository.instance }

  after do
    subject.send(query_method, entity)
  end

  all_callbacks = [
    :before_init,    :after_init,
    :before_load,    :after_load,
    :before_find,    :after_find,
    :before_create,  :after_create,
    :before_update,  :after_update,
    :before_save,    :after_save,
    :before_destroy, :after_destroy
  ]

  non_performed_callbacks = all_callbacks - performed_callbacks

  it "doesn't perform callbacks on #{query_method}" do
    non_performed_callbacks.each do |callback|
      subject.should_not_receive(:performed).with(callback, entity)
    end
  end

  it "performs callbacks on #{query_method} in order" do
    performed_callbacks.each do |callback|
      subject.should_receive(:performed).with(callback, entity).ordered
    end
  end
end

describe Datamappify::Repository do
  let(:valid_user)   { HeroUser.new(:first_name => 'Fred', :last_name => 'Wu', :gender => 'm') }
  let(:invalid_user) { HeroUser.new(:first_name => 'F') }

  it { valid_user.valid?.should == true }
  it { invalid_user.valid?.should == false }

  context "#init" do
    let(:criteria) { HeroUser }
    let(:entity)   { HeroUser.new }

    it "returns entity instead of criteria" do
      HeroUserRepository.instance.should_receive(:performed).with(:before_init, criteria)
      HeroUserRepository.instance.should_receive(:performed).with(:after_init, entity)

      HeroUserRepository.init(criteria)
    end
  end

  context "#find" do
    context "found" do
      let(:criteria) { valid_user.id }
      let(:entity)   { valid_user }

      before do
        HeroUserRepository.save!(valid_user)
      end

      it "returns entity instead of criteria" do
        HeroUserRepository.instance.should_receive(:performed).with(:before_load, criteria)
        HeroUserRepository.instance.should_receive(:performed).with(:before_find, criteria)
        HeroUserRepository.instance.should_receive(:performed).with(:after_find, entity)
        HeroUserRepository.instance.should_receive(:performed).with(:after_load, entity)

        HeroUserRepository.find(criteria)
      end
    end

    context "not found" do
      let(:entity) { 42 }

      it_behaves_like "callbacks", :find,    :before_load, :before_find
    end
  end

  context "non-persisted" do
    context "on valid entity" do
      let(:entity) { valid_user }

      it_behaves_like "callbacks", :create,  :before_load, :before_save, :before_create, :before_create_2, :before_create_block, :after_create, :after_save, :after_load
      it_behaves_like "callbacks", :update,  :before_load, :before_save, :before_update, :after_update, :after_save, :after_load
      it_behaves_like "callbacks", :save,    :before_load, :before_find, :before_load, :before_save, :before_create, :before_create_2, :before_create_block, :after_create, :after_save, :after_load
    end

    context "on invalid entity" do
      let(:entity) { invalid_user }

      it_behaves_like "callbacks", :create,  :before_load, :before_save, :before_create, :before_create_2, :before_create_block
      it_behaves_like "callbacks", :update,  :before_load, :before_save, :before_update
      it_behaves_like "callbacks", :save,    :before_load, :before_find, :before_load, :before_save, :before_create, :before_create_2, :before_create_block
    end
  end

  context "persisted" do
    let!(:persisted_user) { HeroUserRepository.save(valid_user.dup) }

    context "on valid entity" do
      let(:entity) { persisted_user }

      it_behaves_like "callbacks", :create,  :before_load, :before_save, :before_create, :before_create_2, :before_create_block, :after_create, :after_save, :after_load
      it_behaves_like "callbacks", :update,  :before_load, :before_save, :before_update, :after_update, :after_save, :after_load
      it_behaves_like "callbacks", :save,    :before_load, :before_find, :after_find, :after_load, :before_load, :before_save, :before_update, :after_update, :after_save, :after_load
      it_behaves_like "callbacks", :destroy, :before_load, :before_destroy, :after_destroy, :after_load
    end

    context "on invalid entity" do
      let(:entity) { persisted_user.tap { |u| u.first_name = 'f' } }

      it_behaves_like "callbacks", :create,  :before_load, :before_save, :before_create, :before_create_2, :before_create_block
      it_behaves_like "callbacks", :update,  :before_load, :before_save, :before_update
      it_behaves_like "callbacks", :save,    :before_load, :before_find, :after_find, :after_load, :before_load, :before_save, :before_update
      it_behaves_like "callbacks", :destroy, :before_load, :before_destroy, :after_destroy, :after_load
    end
  end

  describe "callbacks chaining" do
    subject { repository.instance }

    describe "chaining breaks before or during saving an entity" do
      after do
        repository.save(entity)

        entity.id.should be_nil
      end

      context "pause at action" do
        let(:entity)     { invalid_user }
        let(:repository) { CallbacksChainingRepository }

        it do
          subject.should_receive(:performed).with(:before_save_1, entity).ordered
          subject.should_receive(:performed).with(:before_save_2, entity).ordered
          subject.should_receive(:performed).with(:before_save_3, entity).ordered
          subject.should_receive(:performed).with(:before_create_1, entity).ordered
          subject.should_receive(:performed).with(:before_create_2, entity).ordered
          subject.should_not_receive(:performed).with(:after_save_1, entity)
          subject.should_not_receive(:performed).with(:after_save_2, entity)
          subject.should_not_receive(:performed).with(:after_save_3, entity)
        end
      end

      context "pause at before callbacks" do
        let(:entity)     { valid_user }
        let(:repository) { CallbacksChainingPauseBeforeRepository }

        it do
          subject.should_receive(:performed).with(:before_save_1, entity).ordered
          subject.should_receive(:performed).with(:before_save_2, entity).ordered
          subject.should_not_receive(:performed).with(:before_save_3, entity)
          subject.should_not_receive(:performed).with(:before_create_1, entity)
          subject.should_not_receive(:performed).with(:before_create_2, entity)
          subject.should_not_receive(:performed).with(:after_save_1, entity)
          subject.should_not_receive(:performed).with(:after_save_2, entity)
          subject.should_not_receive(:performed).with(:after_save_3, entity)
        end
      end
    end

    describe "chaining breaks after saving an entity" do
      after do
        repository.save(entity)

        entity.id.should_not be_nil
      end

      context "pause at after callbacks" do
        let(:entity)     { valid_user }
        let(:repository) { CallbacksChainingPauseAfterRepository }

        it do
          subject.should_receive(:performed).with(:before_save_1, entity).ordered
          subject.should_receive(:performed).with(:before_save_2, entity).ordered
          subject.should_receive(:performed).with(:before_save_3, entity).ordered
          subject.should_receive(:performed).with(:before_create_1, entity).ordered
          subject.should_receive(:performed).with(:before_create_2, entity).ordered
          subject.should_receive(:performed).with(:after_save_1, entity).ordered
          subject.should_receive(:performed).with(:after_save_2, entity).ordered
          subject.should_not_receive(:performed).with(:after_save_3, entity)
        end
      end
    end
  end
end
