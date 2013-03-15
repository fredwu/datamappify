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
    it "requires first name" do
      user.first_name = nil
      user.valid?.must_equal false

      user.first_name = 'Fred'
      user.valid?.must_equal true
    end
  end

  describe "relationships" do
    describe "getters" do
      it "belongs_to" do
        comment.user.must_be_kind_of User
      end

      it "has_one" do
        user.role.must_be_kind_of Role
      end

      it "has_many" do
        user.comments.must_be_kind_of Array
        user.comments.must_be_empty
      end

      it "has_and_belongs_to_many" do
        user.groups.must_be_kind_of Array
        user.groups.must_be_empty
      end
    end

    describe "setters" do
      let(:entity) { Object.new }

      it "belongs_to" do
        comment.user = entity
        comment.user.must_be_kind_of Object
        comment.user.must_equal entity
      end

      it "has_one" do
        user.role = entity
        user.role.must_be_kind_of Object
        user.role.must_equal entity
      end

      it "has_many" do
        user.comments << entity
        user.comments << entity
        user.comments.must_be_kind_of Array
        user.comments.count.must_equal 2
        user.comments[0].must_equal entity

        user.comments = [entity]
        user.comments.count.must_equal 1
      end

      it "has_and_belongs_to_many" do
        user.groups << entity
        user.groups << entity
        user.groups.must_be_kind_of Array
        user.groups.count.must_equal 2
        user.groups[0].must_equal entity

        user.groups = [entity]
        user.groups.count.must_equal 1
      end
    end
  end
end

