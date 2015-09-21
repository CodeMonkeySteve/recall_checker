require 'spec_helper'

describe RecallChecker::Adaptors::Porsche do

    it "loads recall data for VIN WP0CA2A87ES122036 with recalls" do
      VCR.use_cassette('porsche', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Porsche.new("WP0CA2A87ES122036")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "Replace upper part of lid lock"
        expect(r['created_at']).to eq Time.parse("11 Nov 2014")
        expect(r['nhtsa_id']).to eq "14V698"
        expect(r['manufacturer_id']).to eq "AE04"
        expect(r['description']).to start_with "Due to a temporary manufacturing error"
        expect(r['risks']).to start_with "The durability of the upper part of the lock"
        expect(r['remedy']).to start_with "The upper part of the lock"
        expect(r['status']).to eq "Recall status information is not available"
        expect(r['notes']).to eq ""
      end
    end

    it "returns [] for real VIN WP0AA2A80EK170887 with no recalls" do
      VCR.use_cassette('porsche', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Porsche.new("WP0AA2A80EK170887")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN WP0CA2A87ES120000" do
      VCR.use_cassette('porsche', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Porsche.new("WP0CA2A87ES120000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end
end