require 'spec_helper'

# tests for GM makes using Chevrolet VINS
describe RecallChecker::Adaptors::GMMakes do

    it "loads recall data for VIN 2G1FL1EP7E9800295 with a recall" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("2G1FL1EP7E9800295")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "IGNITION KEY"
        expect(r['created_at'].to_date).to eq Date.parse("26 Jun 2014")
        expect(r['nhtsa_id']).to eq "14V346"
        expect(r['manufacturer_id']).to eq "N140294"
        expect(r['description']).to start_with "General Motors has decided"
        expect(r['risks']).to start_with "The timing of the key movement"
        expect(r['remedy']).to start_with "Dealers are to provide"
        expect(r['status']).to eq "11"
        expect(r['notes']).to eq nil
      end
    end

    it "loads recall data for VIN 1G1YM3D7XE5117202 with 2 recalls" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("1G1YM3D7XE5117202")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end


    it "returns [] for real VIN 2G1FT3DW8E9240520 with no recalls" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("2G1FT3DW8E9240520")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN 2G1FT3DW8E9240000" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("2G1FT3DW8E9240000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end