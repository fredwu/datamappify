shared_context "user repository" do |data_provider|
  let(:user_repository)      { "UserRepository#{data_provider}".constantize }
  let!(:existing_user)       { user_repository.save(User.new(:first_name => 'Fred', :last_name => 'Wu', :driver_license => 'FREDWU42', :health_care => 'MEDICARE' )) }
  let(:new_valid_user)       { User.new(:first_name => 'Batman', :last_name => 'DarkKnight', :driver_license => 'ARKHAMCITY', :health_care => 'EXPENSIVE') }
  let(:new_valid_user2)      { User.new(:first_name => 'Ironman', :driver_license => 'NEWYORKCITY') }
  let(:new_invalid_user)     { User.new(:first_name => 'a') }
  let(:new_invalid_user2)    { User.new(:first_name => 'b') }
  let(:data_passports)       { "Datamappify::Data::Record::#{data_provider}::UserPassport".constantize }
  let(:data_driver_licenses) { "Datamappify::Data::Record::#{data_provider}::UserDriverLicense".constantize }
end

shared_context "user repository for finders" do |data_provider|
  include_context "user repository", data_provider

  let!(:existing_user_1) { user_repository.save(new_valid_user.dup) }
  let!(:existing_user_2) { user_repository.save(new_valid_user.dup) }
end
