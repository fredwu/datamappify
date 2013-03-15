require_relative 'spec_helper'

describe Datamappify::Repository do
  let(:user_repository)    { Datamappify::Repository.new(User) }

  describe "ActiveRecord data objects" do
    it "defines the Data::User class after the repository is initialised" do
      user_repository
      Datamappify::Data.const_defined?(:User, false).must_equal true
    end

    describe "data objects" do
      subject { Datamappify::Data::User }

      before do
        user_repository
      end

      it "inherites from Datamappify::Data::Base" do
        subject.superclass.must_equal Datamappify::Data::Base
        subject.ancestors.must_include ActiveRecord::Base
      end

      it "has 'users' as the table name" do
        subject.table_name.must_equal 'users'
      end

      describe "relationships" do
        let(:user)    { Datamappify::Data::User.new }
        let(:comment) { Datamappify::Data::Comment.new }
        let(:role)    { Datamappify::Data::Role.new }
        let(:group)   { Datamappify::Data::Group.new }

        it "belongs_to" do
          assert_correct_associated_data_class_name(comment, :user, 'Datamappify::Data::User')
          comment.user.must_be_nil
        end

        it "has_one" do
          assert_correct_associated_data_class_name(user, :role, 'Datamappify::Data::Role')
          user.role.must_be_nil
        end

        it "has_many" do
          assert_correct_associated_data_class_name(user, :comments, 'Datamappify::Data::Comment')
          assert_correct_associated_data_class_name(role, :users, 'Datamappify::Data::User')
          user.comments.must_be_empty
          role.users.must_be_empty
        end

        it "has_and_belongs_to_many" do
          assert_correct_associated_data_class_name(user, :groups, 'Datamappify::Data::Group')
          assert_correct_associated_data_class_name(group, :users, 'Datamappify::Data::User')
          user.groups.must_be_empty
          group.users.must_be_empty
        end
      end
    end

    def assert_correct_associated_data_class_name(klass, association_name, data_class_name)
      klass.class.reflect_on_all_associations.find { |a|
        a.name == association_name
      }.klass.name.must_equal data_class_name
    end
  end
end
