require 'spec_helper'

shared_examples_for "finder where" do |data_provider|
  include_context "user repository for finders", data_provider

  context "#{data_provider}" do
    describe "#where" do
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

        describe "by attribute that does not exist" do
          let(:records) { user_repository.where(:blah => 'Bob') }

          it { expect { records }.to raise_exception(Datamappify::Data::EntityAttributeInvalid) }
        end

        describe "by primary attribute" do
          let(:records) { user_repository.where(:first_name => 'Bob') }
          subject       { records }

          it { should have(3).users }

          describe "record" do
            subject { records.first }

            its(:first_name)     { should == 'Bob' }
            its(:driver_license) { should == 'IDONTCARE' }
          end
        end

        describe "by secondary attribute" do
          let(:records) { user_repository.where(:driver_license => 'NO_LICENSE') }
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
            let(:records) { user_repository.where(:first_name => 'Bob', :driver_license => 'NO_LICENSE') }
            subject       { records }

            it { should have(1).user }

            describe "record" do
              subject { records.first }

              its(:first_name)     { should == 'Bob' }
              its(:driver_license) { should == 'NO_LICENSE' }
            end
          end

          context "example 2" do
            let(:records) { user_repository.where(:first_name => 'Bob', :driver_license => 'IDONTCARE') }
            subject       { records }

            it { should have(2).users }

            describe "record" do
              subject { records.first }

              its(:first_name)     { should == 'Bob' }
              its(:driver_license) { should == 'IDONTCARE' }
            end
          end

          context "example 3" do
            subject { user_repository.where(:first_name => 'Nope', :driver_license => 'IDONTCARE') }

            it { should be_empty }
          end

          context "example 4" do
            subject { user_repository.where(:first_name => 'Bob', :driver_license => 'NOPE') }

            it { should be_empty }
          end

          context "example 5 (string keys)" do
            let(:records) { user_repository.where('first_name' => 'Bob', 'driver_license' => 'IDONTCARE') }
            subject       { records }

            it { should have(2).users }

            describe "record" do
              subject { records.first }

              its(:first_name)     { should == 'Bob' }
              its(:driver_license) { should == 'IDONTCARE' }
            end
          end
        end
      end
    end
  end
end

describe Datamappify::Repository do
  DATA_PROVIDERS.each do |data_provider|
    it_behaves_like "finder where", data_provider
  end
end
