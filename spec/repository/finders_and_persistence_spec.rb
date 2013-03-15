require_relative '../spec_helper'

describe Datamappify::Repository do
  let(:user_repository) { UserRepository.instance }
  let(:user)            { user_repository.first }
  let(:user_valid)      { User.new(:first_name => 'Batman') }
  let(:user_invalid)    { User.new(:first_name => 'a') }

  before do
    user_repository
    Datamappify::Data::User.create!(:first_name => 'Fred')
  end

  describe "single record" do
    it "#find" do
      user_repository.find(1).must_equal user
      user_repository.find([1]).must_equal [user]
    end

    it "#save success" do
      new_user = user_repository.save(user_valid)
      new_user.must_be_kind_of User
      new_user.first_name.must_equal 'Batman'
    end

    it "#save! failure" do
      -> { user_repository.save!(user_invalid) }.must_raise ActiveRecord::RecordInvalid
    end

    it "updates an existing record" do
      user.first_name = 'Steve'
      changed_user = User.new(user.attributes)
      user_repository.save(changed_user).first_name.must_equal 'Steve'
      user_repository.count.must_equal 1
    end

    it "#destroy via id" do
      user_repository.destroy(1)
      user_repository.count.must_equal 0
    end

    it "#destroy via entity" do
      user_repository.destroy(user.entity)
      user_repository.count.must_equal 0
    end
  end

  describe "collection records" do
    it "#find" do
      user_repository.all.must_be_kind_of ActiveRecord::Relation::ActiveRecord_Relation_Datamappify_Data_User
      user_repository.count.must_equal 1
    end

    it "#save" do
      new_user_entity = user.entity
      new_user_entity.id = nil

      new_users = user_repository.save([new_user_entity, user_valid])
      new_users[0].first_name.must_equal 'Fred'
      new_users[1].first_name.must_equal 'Batman'

      user_repository.count.must_equal 3
      user_repository.all[0].first_name.must_equal 'Fred'
      user_repository.all[1].first_name.must_equal 'Fred'
      user_repository.all[2].first_name.must_equal 'Batman'
    end
  end
end
