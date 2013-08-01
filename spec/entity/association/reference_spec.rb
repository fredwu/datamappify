require 'spec_helper'

shared_examples_for "entity association reference" do |data_provider|
  context "#{data_provider}" do
    include_context "user repository", data_provider

    let!(:comment_repository) { "CommentRepository#{data_provider}".constantize }
    let(:comment)             { comment_repository.save!(Comment.new) }

    subject { comment }

    before do
      subject.user = existing_user
    end

    its(:user_id) { should == existing_user.id }
    its(:user)    { should == existing_user }
  end
end

describe Datamappify::Entity do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "entity association reference", data_provider
  end
end
