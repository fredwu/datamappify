require 'spec_helper'

module Datamappify::Repository::QueryMethod
  describe Datamappify::Repository::QueryMethod do
    describe Method do
      subject { Method }

      it { should_not be_a_reader }
      it { should_not be_a_writer }
    end

    describe Count do
      subject { Count }

      it { should     be_a_reader }
      it { should_not be_a_writer }
    end

    describe Destroy do
      subject { Destroy }

      it { should_not be_a_reader }
      it { should     be_a_writer }
    end

    describe Find do
      subject { Find }

      it { should     be_a_reader }
      it { should_not be_a_writer }
    end

    describe Save do
      subject { Save }

      it { should_not be_a_reader }
      it { should     be_a_writer }
    end

    RSpec::Matchers.define :be_a_reader do
      match { |method| query_method(method).reader? == true }
    end

    RSpec::Matchers.define :be_a_writer do
      match { |method| query_method(method).writer? == true }
    end

    def query_method(method)
      Datamappify::Repository::QueryMethod.const_get(
        method.to_s
      ).new({}, {})
    end
  end
end
