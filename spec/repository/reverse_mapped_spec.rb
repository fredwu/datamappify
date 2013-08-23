require 'spec_helper'

shared_examples_for "reverse mapped" do |data_provider|
  let!(:author_repository) { "Reversed::AuthorRepository#{data_provider}".constantize }
  let!(:post_repository)   { "Reversed::PostRepository#{data_provider}".constantize }
  let(:new_author)         { Reversed::Author.new(:name => 'George R. R. Martin', :bio => 'GoT') }
  let(:new_post)           { Reversed::Post.new(:title => 'Hello world', :author_name => 'Fred Wu', :author_bio => 'x')}
  let(:new_post_2)         { Reversed::Post.new(:title => 'Hello earth', :author_name => 'Sheldon Cooper', :author_bio => 'y')}
  let(:data_authors)       { "Datamappify::Data::Record::#{data_provider}::Reversed::Author".constantize }
  let(:data_posts)         { "Datamappify::Data::Record::#{data_provider}::Reversed::Post".constantize }

  context "#{data_provider}" do
    before do
      author_repository.save!(new_author)
    end

    describe "persistence" do
      before do
        post_repository.save!(new_post_2)
      end

      describe "referenced entity" do
        subject { post_repository.save!(new_post) }

        its(:title)       { should == 'Hello world' }
        its(:author_name) { should == 'Fred Wu' }
        its(:author_bio)  { should == 'x' }
      end

      describe "new found entity" do
        let!(:saved_post)   { post_repository.save!(new_post) }
        let!(:saved_post_2) { post_repository.save!(new_post_2) }

        context "record 1" do
          subject { post_repository.find(saved_post.id) }

          its(:title)       { should == 'Hello world' }
          its(:author_name) { should == 'Fred Wu' }
          its(:author_bio)  { should == 'x' }
        end

        context "record 2" do
          subject { post_repository.find(saved_post_2.id) }

          its(:title)       { should == 'Hello earth' }
          its(:author_name) { should == 'Sheldon Cooper' }
          its(:author_bio)  { should == 'y' }
        end

        describe "update record" do
          let(:record) { post_repository.find(saved_post.id) }

          describe "data records" do
            it "does not create extra primary data records" do
              expect { post_repository.save!(record) }.to change { data_posts.count }.by(0)
            end

            it "does not create extra secondary data records" do
              expect { post_repository.save!(record) }.to change { data_authors.count }.by(0)
            end

            it "does not change data record's foreign key value" do
              expect { post_repository.save!(record) }.not_to change { data_posts.last.author_id }
            end
          end

          context "example 1" do
            subject { post_repository.save!(record) }

            its(:title)       { should == 'Hello world' }
            its(:author_name) { should == 'Fred Wu' }
            its(:author_bio)  { should == 'x' }
          end

          context "example 2" do
            subject { post_repository.find(record.id) }

            before do
              record.title = 'Hello mars'
              record.author_name = 'JK Rowling'
              post_repository.save!(record)
            end

            its(:title)       { should == 'Hello mars' }
            its(:author_name) { should == 'JK Rowling' }
            its(:author_bio)  { should == 'x' }
          end
        end
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "reverse mapped", data_provider
  end
end
