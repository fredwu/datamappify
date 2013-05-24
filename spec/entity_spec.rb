require_relative 'spec_helper'

describe Datamappify::Entity do
  let(:user)    { User.new }
  let(:role)    { Role.new }
  let(:comment) { Comment.new }

  describe "attributes" do
    it "has defined attributes" do
      user.first_name.should be_nil
      user.last_name.should be_nil
    end

    it "raises error on undefined attributes" do
      -> { user.surname }.should raise_error(NoMethodError)
    end

    it "assigns an attribute" do
      user.first_name = 'Fred'
      user.first_name.should == 'Fred'
    end

    it "coerces an attribute" do
      user.age = '42'
      user.age.should be_kind_of(Fixnum)
      user.age.should == 42
    end
  end

  describe "validations" do
    it "validates attributes" do
      user.valid?.should == false

      user.first_name = 'Fred'
      user.driver_license = 'FREDWU42'
      user.valid?.should == true
    end
  end

  describe "conversion" do
    subject { user }

    it { should respond_to(:to_key) }
  end
end

