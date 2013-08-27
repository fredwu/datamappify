shared_context "where or match context" do
  let(:bob)        { 'Bob' }
  let(:license)    { 'YESLICENSE' }
  let(:no_license) { 'NO_LICENSE' }
end

shared_examples_for "where or match finder" do |finder|
  subject { records }

  before do
    user_repository.save!(User.new(:first_name => 'Mary', :driver_license => 'YESLICENSE'))
    user_repository.save!(User.new(:first_name => 'Bob',  :driver_license => 'YESLICENSE', :personal_info => 'Ok'))
    user_repository.save!(User.new(:first_name => 'Jane', :driver_license => 'NO_LICENSE', :business_info => 'Ok'))
    user_repository.save!(User.new(:first_name => 'Bob',  :driver_license => 'NO_LICENSE'))
    user_repository.save!(User.new(:first_name => 'Bob',  :driver_license => 'YESLICENSE', :business_info => 'No'))
    user_repository.save!(User.new(:first_name => 'Bobb', :driver_license => 'YESLICENSE'))
    user_repository.save!(User.new(:first_name => 'John', :driver_license => 'YESLICENSE'))
  end

  describe "by attribute that does not exist" do
    let(:records) { user_repository.send(finder, :blah => bob) }

    it { expect { records }.to raise_exception(Datamappify::Data::EntityAttributeInvalid) }
  end

  describe "by primary attribute" do
    let(:records) { user_repository.send(finder, :first_name => bob) }

    it { should have(3).users }

    describe "record" do
      subject { records.first }

      its(:first_name)     { should == 'Bob' }
      its(:driver_license) { should == 'YESLICENSE' }
    end
  end

  describe "by secondary attribute" do
    let(:records) { user_repository.send(finder, :driver_license => no_license) }

    it { should have(2).users }

    describe "record" do
      subject { records.first }

      its(:first_name)     { should == 'Jane' }
      its(:driver_license) { should == 'NO_LICENSE' }
    end
  end

  describe "by primary and secondary attributes" do
    context "example 1" do
      let(:records) { user_repository.send(finder, :first_name => bob, :driver_license => no_license) }
      subject       { records }

      it { should have(1).user }

      describe "record" do
        subject { records.first }

        its(:first_name)     { should == 'Bob' }
        its(:driver_license) { should == 'NO_LICENSE' }
      end
    end

    context "example 2" do
      let(:records) { user_repository.send(finder, :first_name => bob, :driver_license => license) }
      subject       { records }

      it { should have(2).users }

      describe "record" do
        subject { records.first }

        its(:first_name)     { should == 'Bob' }
        its(:driver_license) { should == 'YESLICENSE' }
      end
    end

    context "example 3" do
      subject { user_repository.send(finder, :first_name => 'Nope', :driver_license => license) }

      it { should be_empty }
    end

    context "example 4" do
      subject { user_repository.send(finder, :first_name => bob, :driver_license => 'NOPE') }

      it { should be_empty }
    end

    context "example 5 (string keys)" do
      let(:records) { user_repository.send(finder, 'first_name' => bob, 'driver_license' => license) }

      it { should have(2).users }

      describe "record" do
        subject { records.first }

        its(:first_name)     { should == 'Bob' }
        its(:driver_license) { should == 'YESLICENSE' }
      end
    end
  end

  describe "by reverse mapped attribute" do
    let(:records) { user_repository.send(finder, :business_info => 'Ok') }

    it { should have(1).user }

    context "record" do
      subject { records.first }

      its(:personal_info) { should be_nil }
    end
  end
end
