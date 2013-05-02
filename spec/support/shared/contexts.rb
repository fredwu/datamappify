shared_context "user repository" do |data_provider|
  let!(:user_repository)     { "UserRepository#{data_provider}".constantize }
  let!(:existing_user)       { user_repository.save(User.new(:first_name => 'Fred', :driver_license => 'FREDWU42')) }
  let(:new_valid_user)       { User.new(:first_name => 'Batman', :driver_license => 'ARKHAMCITY') }
  let(:new_valid_user2)      { User.new(:first_name => 'Ironman', :driver_license => 'NEWYORKCITY') }
  let(:new_invalid_user)     { User.new(:first_name => 'a') }
  let(:new_invalid_user2)    { User.new(:first_name => 'b') }
  let(:data_passports)       { "Datamappify::Data::Record::#{data_provider}::UserPassport".constantize }
  let(:data_driver_licenses) { "Datamappify::Data::Record::#{data_provider}::UserDriverLicense".constantize }
end
