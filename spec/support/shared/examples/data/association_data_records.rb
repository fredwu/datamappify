shared_examples_for "association data records" do |data_provider|
  let(:data_groups)               { "Datamappify::Data::Record::#{data_provider}::Group".constantize }
  let(:data_super_users)          { "Datamappify::Data::Record::#{data_provider}::SuperUser".constantize }
  let(:data_users)                { "Datamappify::Data::Record::#{data_provider}::User".constantize }
  let(:data_user_driver_licenses) { "Datamappify::Data::Record::#{data_provider}::UserDriverLicense".constantize }

  before do
    saved_group
  end

  describe "data records" do
    it "does not create extra primary data records" do
      expect { saved_group }.to change { data_groups.count }.by(0)
    end

    it "does not create extra associated primary data records" do
      expect { saved_group }.to change { data_super_users.count }.by(0)
    end

    it "does not create extra associated secondary data records" do
      expect { saved_group }.to change { data_users.count }.by(0)
    end

    it "does not create extra secondary data records" do
      expect { saved_group }.to change { data_user_driver_licenses.count }.by(0)
    end
  end
end
