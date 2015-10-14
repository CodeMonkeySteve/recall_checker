require 'spec_helper'

describe RecallChecker::Adaptors::Volvo do

    it "loads recall data for VIN YV1622FSXC2140424 with an open recall" do
      VCR.use_cassette('volvo', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volvo.new("YV1622FSXC2140424")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "Recall R29436: Oil Pressure Sensor"
        expect(r['created_at'].to_date).to eq Date.parse("3 Dec 2013")
        expect(r['nhtsa_id']).to eq "13V592"
        expect(r['manufacturer_id']).to eq "R29436"
        expect(r['description']).to start_with "Recall R29436: Oil Pressure Sensor"
        expect(r['risks']).to start_with "Volvo Cars of North America, LLC"
        expect(r['remedy']).to start_with "The corrective action"
        expect(r['status']).to start_with "Recall INCOMPLETE"
        expect(r['notes']).to start_with "For Recalls prior to August 1999"
      end
    end

    it "loads recall data for VIN YV1622FS8C2129437 with 2 open recalls" do
      VCR.use_cassette('volvo', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volvo.new("YV1622FS8C2129437")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end

    it "loads recall data for VIN YV126MFK0G2397287 with open recalls but no info" do
      VCR.use_cassette('volvo', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volvo.new("YV126MFK0G2397287")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq nil
        expect(r['created_at']).to eq nil
        expect(r['nhtsa_id']).to eq nil
        expect(r['manufacturer_id']).to eq nil
        expect(r['description']).to eq nil
        expect(r['risks']).to eq nil
        expect(r['remedy']).to eq nil
        expect(r['status']).to eq nil
        expect(r['notes']).to eq nil
      end
    end

    it "returns [] for real VIN YV1992AHXA1114123 with no recalls" do
      VCR.use_cassette('volvo', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volvo.new("YV1992AHXA1114123")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN YV1992AHXA1110000" do
      VCR.use_cassette('volvo', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volvo.new("YV1992AHXA1110000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end