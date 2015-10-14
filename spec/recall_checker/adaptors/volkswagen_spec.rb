require 'spec_helper'

describe RecallChecker::Adaptors::Volkswagen do

    it "loads recall data for VIN 3VW517AT4EM819423 with recalls" do
      VCR.use_cassette('volkswagen', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volkswagen.new("3VW517AT4EM819423")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "Fuel Rail"
        expect(r['created_at'].to_date).to eq Date.parse("22 Jan 2015")
        expect(r['nhtsa_id']).to eq "15V-028"
        expect(r['manufacturer_id']).to eq "24BL"
        expect(r['description']).to start_with "During engine operation"
        expect(r['risks']).to start_with "Leaking fuel"
        expect(r['remedy']).to start_with "Replace the fuel rail"
        expect(r['status']).to eq "11"
        expect(r['notes']).to eq " "
      end
    end

    it "returns [] for real VIN 3VWFP7ATXEM621206 with no recalls" do
      VCR.use_cassette('volkswagen', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volkswagen.new("3VWFP7ATXEM621206")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN 3VWFP7ATXEM620000" do
      VCR.use_cassette('volkswagen', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Volkswagen.new("3VWFP7ATXEM620000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end