require 'spec_helper'

module Datamappify::Entity
  describe Datamappify::Entity::Composable do
    class FarDistantEntity
      include Datamappify::Entity

      attribute :far_distant_attribute_one, String
    end

    class DistantEntity
      include Datamappify::Entity

      attribute :distant_attribute_one, String
      attribute :distant_attribute_two, Integer, :default => 42

      references :far_distant_entity

      attributes_from FarDistantEntity, :prefix_with => :far
    end

    class AnotherEntity
      include Datamappify::Entity

      attribute :attribute_one, String, :default => 'Hello'
      attribute :attribute_two, Integer

      references :distant_entity

      attributes_from DistantEntity
    end

    class DummyEntity
      include Datamappify::Entity

      attribute :attribute_zero, String

      attributes_from AnotherEntity, :prefix_with => :other
    end

    subject { DummyEntity.new }

    describe "#attributes_from" do
      its(:attributes) { should have_key(:attribute_zero) }
      its(:attributes) { should have_key(:other_attribute_one) }
      its(:attributes) { should have_key(:other_attribute_two) }
      its(:attributes) { should have_key(:other_distant_attribute_one) }
      its(:attributes) { should have_key(:other_distant_attribute_two) }
      its(:attributes) { should have_key(:other_far_far_distant_attribute_one) }
      its(:attributes) { should have_key(:other_distant_entity_id) }
      its(:attributes) { should have_key(:other_far_distant_entity_id) }

      its(:attributes) { should_not have_key(:attribute_one) }
      its(:attributes) { should_not have_key(:attribute_two) }
      its(:attributes) { should_not have_key(:distant_attribute_one) }
      its(:attributes) { should_not have_key(:distant_attribute_two) }

      its(:attributes) { should_not have_key(:distant_entity_id) }
      its(:attributes) { should_not have_key(:far_distant_entity_id) }
      its(:attributes) { should_not have_key(:far_far_distant_entity_id) }

      its(:other_attribute_one)   { should == 'Hello' }
      its(:other_distant_attribute_two) { should == 42 }
    end
  end
end
