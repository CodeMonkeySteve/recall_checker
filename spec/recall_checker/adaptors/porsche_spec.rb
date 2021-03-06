require 'spec_helper'

describe RecallChecker::Adaptors::Porsche do

    it "loads recall data for VIN WP0CA2A87ES122036 with recalls" do
      VCR.use_cassette('porsche', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Porsche.new("WP0CA2A87ES122036")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "Replace upper part of lid lock"
        expect(r['created_at']).to eq Date.parse("11 Nov 2014")
        expect(r['nhtsa_id']).to eq "14V698"
        expect(r['manufacturer_id']).to eq "AE04"
        expect(r['description']).to start_with "Due to a temporary manufacturing error"
        expect(r['risks']).to start_with "The durability of the upper part of the lock"
        expect(r['remedy']).to start_with "The upper part of the lock"
        expect(r['status']).to eq nil
        expect(r['notes']).to eq nil
      end
    end

    it "returns [] for real VIN WP0AA2A80EK170887 with no recalls" do
      VCR.use_cassette('porsche', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Porsche.new("WP0AA2A80EK170887")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN 1G1YM3D7XE5117202" do
      VCR.use_cassette('porsche', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Porsche.new("1G1YM3D7XE5117202")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end
end