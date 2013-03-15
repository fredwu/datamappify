require_relative 'spec_helper'

describe Datamappify::Repository do
  let(:user_repository)    { UserRepository.instance }
  let(:comment_repository) { CommentRepository.instance }
  let(:role_repository)    { RoleRepository.instance }
  let(:group_repository)   { GroupRepository.instance }

  before do
    user_repository
    comment_repository
    role_repository
    group_repository
  end

  describe "ActiveRecord data objects" do
    it "defines the Data::User class after the repository is initialised" do
      Datamappify::Data.const_defined?(:User, false).must_equal true
    end

    describe "data objects" do
      subject { Datamappify::Data::User }

      it "inherites from Datamappify::Data::Base" do
        subject.superclass.must_equal Datamappify::Data::Base
        subject.ancestors.must_include ActiveRecord::Base
      end

      it "has 'users' as the table name" do
        subject.table_name.must_equal 'users'
      end
    end

    def assert_correct_associated_data_class_name(klass, association_name, data_class_name)
      klass.class.reflect_on_all_associations.find { |a|
        a.name == association_name
      }.klass.name.must_equal data_class_name
    end
  end
end
