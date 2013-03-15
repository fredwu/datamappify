require_relative 'spec_helper'

describe Datamappify::Entity do
  let(:user)    { User.new }
  let(:role)    { Role.new }
  let(:comment) { Comment.new }

  describe "attributes" do
    it "has defined attributes" do
      user.first_name.must_be_nil
    end

    it "raises error on undefined attributes" do
      -> { user.attribute_that_does_not_exist }.must_raise NoMethodError
    end

    it "assigns an attribute" do
      user.first_name = 'Fred'
      user.first_name.must_equal 'Fred'
    end

    it "coerces an attribute" do
      user.age = '42'
      user.age.must_be_kind_of Fixnum
      user.age.must_equal 42
    end
  end

  describe "validations" do
    it "validates attributes" do
      user.valid?.must_equal false

      user.first_name = 'Fred'
      user.passport = 'FREDWU42'
      user.valid?.must_equal true
    end
  end
end

