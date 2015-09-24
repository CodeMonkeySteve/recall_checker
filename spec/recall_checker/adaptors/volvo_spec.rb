require 'spec_helper'

describe RecallChecker::Adaptors::Volvo do

    it "loads recall data for VIN YV126MFK0G2397287 with recalls" do
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