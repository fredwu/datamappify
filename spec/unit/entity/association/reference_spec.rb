require 'spec_helper'

module Datamappify::Entity
  describe Datamappify::Entity::Association::Reference do
    class DummyEntityAssociationReferenceA
      include Datamappify::Entity

      references :another_entity
    end

    class DummyEntityAssociationReferenceB
      include Datamappify::Entity
    end

    subject { DummyEntityAssociationReferenceA.new }

    describe "#references" do
      let(:another_entity) { DummyEntityAssociationReferenceB.new.tap { |e| e.id = 42 } }

      it { should respond_to(:another_entity_id) }
      it { should respond_to(:another_entity_id=) }
      it { should respond_to(:another_entity) }
      it { should respond_to(:another_entity=) }

      describe "assigns the correct attribute" do
        before do
          subject.another_entity = another_entity
        end

        its(:another_entity_id) { should == 42 }
        its(:another_entity)    { should == another_entity }
        its(:reference_keys)    { should include(:another_entity_id) }
      end

      describe "assigns nil" do
        before do
          subject.another_entity = nil
        end

        its(:another_entity_id) { should be_nil }
        its(:another_entity)    { should be_nil }
        its(:reference_keys)    { should include(:another_entity_id) }
      end
    end
  end
end
