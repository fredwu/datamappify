require 'spec_helper'

module Datamappify::Entity
  describe Datamappify::Entity::Relation do
    class DummyEntity
      include Datamappify::Entity

      references :another_entity
    end

    class AnotherEntity
      include Datamappify::Entity
    end

    subject { DummyEntity.new }

    describe "#references" do
      it { should respond_to(:another_entity_id) }
      it { should respond_to(:another_entity_id=) }
      it { should respond_to(:another_entity) }
      it { should respond_to(:another_entity=) }

      describe "assigns the correct attribute" do
        let(:another_entity) { AnotherEntity.new.tap { |e| e.id = 42 } }

        before do
          subject.another_entity = another_entity
        end

        its(:another_entity_id) { should == 42 }
        its(:another_entity)    { should == another_entity }
        its(:reference_keys)    { should include(:another_entity_id) }
      end
    end
  end
end
