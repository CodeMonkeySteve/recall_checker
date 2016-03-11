require 'spec_helper'

describe RecallChecker::Adaptors::Recallmasters do

    # Don't forget to insert the real key if you need to run these tests without VCR!
    before :each do
      RecallChecker::Adaptors::Recallmasters.set_access_key("FAKE_KEY")
    end

    it "loads recall data for VIN 1ZVBP8AMXD5277023 with a recall" do
      VCR.use_cassette('recallmasters', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Recallmasters.new("1ZVBP8AMXD5277023")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "Driver Airbag Inflator may be Defective and Cause injury During a Crash"
        expect(r['created_at']).to eq Date.parse("27 May 2015")
        expect(r['nhtsa_id']).to eq "15V319000"
        expect(r['manufacturer_id']).to eq "FORD 15S21"
        expect(r['description']).to start_with "Safety Risk - Driver Airbag Inflator"
        expect(r['risks']).to start_with "In Inflator Rupture Could Result"
        expect(r['remedy']).to start_with "Dealers Will Replace The Driver Airbag"
      end
    end

    it "loads recall data for VIN 3FA6P0H79DR185703 with two recalls" do
      VCR.use_cassette('recallmasters', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Recallmasters.new("3FA6P0H79DR185703")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end

    it "returns [] for real VIN 1FM5K7B96EGA76353 with no recalls" do
      VCR.use_cassette('recallmasters', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Recallmasters.new("1FM5K7B96EGA76353")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN 11111111111111111" do
      VCR.use_cassette('recallmasters', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Recallmasters.new("11111111111111111")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end