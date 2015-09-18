require 'spec_helper'

describe RecallChecker::Adaptors::Mitsubishi do

    it "loads recall data for VIN JA3215H17CU014800 with recalls" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("JA3215H17CU014800")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "DUE TO EITHER OF THE FOLLOWING REASONS"
        expect(r['created_at']).to eq Time.parse("29 Aug 2014")
        expect(r['nhtsa_id']).to eq "14V522"
        expect(r['manufacturer_id']).to eq "SR-14-007"
        expect(r['description']).to start_with "DUE TO EITHER OF THE FOLLOWING REASONS"
        expect(r['risks']).to start_with "BRAKE VACUUM PUMP INOPERABILITY"
        expect(r['remedy']).to start_with "THE DEALERSHIP WILL REPROGRAM"
        expect(r['status']).to eq "Recall status information is not available"
        expect(r['notes']).to eq ""
      end
    end

    it "returns [] for real VIN JA4AZ3A32GZ004183 with no recalls" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("JA4AZ3A32GZ004183")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN JA4AZ3A32GZ000000" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("JA4AZ3A32GZ000000")
        expect(@checker.vin_invalid?).to eq true
      end
    end

end