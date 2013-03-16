require_relative '../spec_helper'

describe Datamappify::Repository do
  let(:user_repository) { UserRepository.instance }
  let(:user)            { User.new(:id => 1, :first_name => 'Fred', :passport => 'FREDWU42') }
  let(:user_valid)      { User.new(:first_name => 'Batman', :passport => 'ARKHAMCITY') }
  let(:user_invalid)    { User.new(:first_name => 'a') }

  let(:has_db_user) do
    Datamappify::Data::User.create!(:first_name => 'Fred')
    Datamappify::Data::UserPassport.create!(:number => 'FREDWU42', :user_id => 1)
  end

  before do
    user_repository
  end

  it "#find" do
    has_db_user

    user_repository.find(1).must_equal user
    user_repository.find([1]).must_equal [user]
  end

  describe "#save" do
    it "success" do
      user_repository.save(user_valid)
      user_repository.count.must_equal 1

      new_user = user_repository.find(1)
      new_user.must_be_kind_of User
      new_user.first_name.must_equal 'Batman'
      new_user.passport.must_equal 'ARKHAMCITY'
    end

    it "failure" do
      -> { user_repository.save!(user_invalid) }.must_raise Datamappify::Data::EntityNotSaved
    end
  end

  it "updates an existing record" do
    has_db_user

    user.first_name = 'Steve'
    user.gender = 'male'
    user.passport = 'LOCOMOTE'

    updated_user = user_repository.save(user)
    updated_user.first_name.must_equal 'Steve'
    updated_user.gender.must_equal 'male'
    updated_user.passport.must_equal 'LOCOMOTE'

    persisted_user = user_repository.find(user.id)
    persisted_user.first_name.must_equal 'Steve'
    persisted_user.gender.must_equal 'male'
    persisted_user.passport.must_equal 'LOCOMOTE'

    user_repository.count.must_equal 1
  end

  it "#destroy via id" do
    has_db_user

    user_repository.destroy!(1)
    user_repository.count.must_equal 0
  end

  it "#destroy via entity" do
    has_db_user

    user_repository.destroy!(user)
    user_repository.count.must_equal 0
  end
end
