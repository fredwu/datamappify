require 'spec_helper'

module Datamappify::Entity
  describe Datamappify::Entity::Relation do
    class DummyEntity
      include Datamappify::Entity

      references :another_entity
    end

    subject { DummyEntity.new }

    describe "#references" do
      it { should respond_to(:another_entity_id) }
      it { should respond_to(:another_entity_id=) }
    end
  end
end
