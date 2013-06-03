require 'spec_helper'

shared_examples_for "finders" do |data_provider|
  include_context "user repository", data_provider

  let!(:existing_user_1) { user_repository.save(new_valid_user.dup) }
  let!(:existing_user_2) { user_repository.save(new_valid_user.dup) }

  context "#{data_provider}" do
    describe "#find" do
      describe "by id" do
        subject { user_repository.find(existing_user.id) }

        its(:id) { should == existing_user.id }
      end

      describe "by criteria" do
        before do
          user_repository.save!(User.new(:first_name => 'Mary', :driver_license => 'IDONTCARE'))
          user_repository.save!(User.new(:first_name => 'Bob', :driver_license => 'IDONTCARE'))
          user_repository.save!(User.new(:first_name => 'Jane', :driver_license => 'NO_LICENSE'))
          user_repository.save!(User.new(:first_name => 'Bob', :driver_license => 'NO_LICENSE'))
          user_repository.save!(User.new(:first_name => 'Bob', :driver_license => 'IDONTCARE'))
          user_repository.save!(User.new(:first_name => 'Bobb', :driver_license => 'IDONTCARE'))
          user_repository.save!(User.new(:first_name => 'John', :driver_license => 'IDONTCARE'))
        end

        describe "by primary attribute" do
          let(:records) { user_repository.find(:first_name => 'Bob') }
          subject       { records }

          it { should have(3).users }

          describe "record" do
            subject { records.first }

            its(:first_name)     { should == 'Bob' }
            its(:driver_license) { should == 'IDONTCARE' }
          end
        end

        describe "by secondary attribute" do
          let(:records) { user_repository.find(:driver_license => 'NO_LICENSE') }
          subject       { records }

          it { should have(2).user }

          describe "record" do
            subject { records.first }

            its(:first_name)     { should == 'Jane' }
            its(:driver_license) { should == 'NO_LICENSE' }
          end
        end

        describe "by primary and secondary attributes" do
          context "example 1" do
            let(:records) { user_repository.find(:first_name => 'Bob', :driver_license => 'NO_LICENSE') }
            subject       { records }

            it { should have(1).user }

            describe "record" do
              subject { records.first }

              its(:first_name)     { should == 'Bob' }
              its(:driver_license) { should == 'NO_LICENSE' }
            end
          end

          context "example 2" do
            let(:records) { user_repository.find(:first_name => 'Bob', :driver_license => 'IDONTCARE') }
            subject       { records }

            it { should have(2).users }

            describe "record" do
              subject { records.first }

              its(:first_name)     { should == 'Bob' }
              its(:driver_license) { should == 'IDONTCARE' }
            end
          end

          context "example 3" do
            subject { user_repository.find(:first_name => 'Nope', :driver_license => 'IDONTCARE') }

            it { should be_empty }
          end

          context "example 4" do
            subject { user_repository.find(:first_name => 'Bob', :driver_license => 'NOPE') }

            it { should be_empty }
          end
        end
      end
    end

    describe "#all" do
      let(:records) { user_repository.all }
      subject       { records }

      it { should have(3).users }

      its(:first) { should == existing_user }
      its(:last)  { should == existing_user_2 }

      describe "record" do
        subject { records.first }

        its(:first_name) { should == existing_user.first_name }
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finders", data_provider
  end
end

describe "attributes from different data providers" do
  before do
    pending

    HeroUserRepository.save!(HeroUser.new(:first_name => 'Fred', :last_name => 'Wu'))
    HeroUserRepository.save!(HeroUser.new(:first_name => 'Sheldon', :last_name => 'Cooper'))
    HeroUserRepository.save!(HeroUser.new(:first_name => 'Fred', :last_name => 'Cooper'))
  end

  context "example 1" do
    let(:records) { HeroUserRepository.find(:first_name => 'Fred') }
    subject       { records }

    it { should have(2).users }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Fred' }
      its(:last_name)  { should == 'Wu' }
    end
  end

  context "example 2" do
    let(:records) { HeroUserRepository.find(:first_name => 'Sheldon') }
    subject       { records }

    it { should have(1).user }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Sheldon' }
      its(:last_name)  { should == 'Cooper' }
    end
  end

  context "example 3" do
    let(:records) { HeroUserRepository.find(:last_name => 'Cooper') }
    subject       { records }

    it { should have(2).users }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Sheldon' }
      its(:last_name)  { should == 'Cooper' }
    end
  end

  context "example 4" do
    let(:records) { HeroUserRepository.find(:first_name => 'Sheldon', :last_name => 'Cooper') }
    subject       { records }

    it { should have(1).user }

    describe "record" do
      subject { records.first }

      its(:first_name) { should == 'Sheldon' }
      its(:last_name)  { should == 'Cooper' }
    end
  end

  context "example 5" do
    let(:records) { HeroUserRepository.find(:first_name => 'Leonard', :last_name => 'Cooper') }
    subject       { records }

    it { should be_empty }
  end

  context "example 6" do
    let(:records) { HeroUserRepository.find(:first_name => 'Fred', :last_name => 'Woo') }
    subject       { records }

    it { should be_empty }
  end
end
