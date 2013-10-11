require 'spec_helper'

module Datamappify::Entity
  describe Datamappify::Entity::Compatibility::ActiveRecord do
    class DummyEntityCompatibilityActiveRecordA
      include Datamappify::Entity
    end

    class DummyEntityCompatibilityActiveRecordB
      include Datamappify::Entity

      has_many :other_dummies, :via => DummyEntityCompatibilityActiveRecordA
    end

    subject { DummyEntityCompatibilityActiveRecordB.reflect_on_association(:other_dummies) }

    its(:klass) { should == DummyEntityCompatibilityActiveRecordA }
  end
end
