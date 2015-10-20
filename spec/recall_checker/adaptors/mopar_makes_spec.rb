require 'spec_helper'

# tests for Mopar makes using Chrysler VINS
describe RecallChecker::Adaptors::MoparMakes do

    it "loads recall data for VIN 2C4RC1BG1ER211106 with an open recall" do
      VCR.use_cassette('chrysler', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chrysler.new("2C4RC1BG1ER211106")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "THE REAR QUARTER VENT WINDOW SWITCH ON YOUR VEHICLE MAY OVERHEAT"
        expect(r['created_at']).to eq Date.parse("06 May 2014")
        expect(r['nhtsa_id']).to eq "14V-234"
        expect(r['manufacturer_id']).to eq "P25"
        expect(r['description']).to start_with "THE REAR QUARTER VENT WINDOW SWITCH ON YOUR VEHICLE MAY OVERHEAT"
        expect(r['risks']).to start_with "THE REAR QUARTER VENT WINDOW SWITCH ON YOUR VEHICLE MAY OVERHEAT"
        expect(r['remedy']).to start_with "THE REAR QUARTER VENT WINDOW SWITCH MUST BE REPLACED"
        expect(r['status']).to start_with "INCOMPLETE BUT REPAIR PARTS ARE AVAILABLE"
        expect(r['notes']).to eq nil
      end
    end

    it "loads recall data for VIN 2C4RC1CG7DR569002 with 2 open recalls" do
      VCR.use_cassette('chrysler', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chrysler.new("2C4RC1CG7DR569002")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end

    it "returns [] for real VIN 2C4RC1BG8ER138686 with closed recalls only" do
      VCR.use_cassette('chrysler', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chrysler.new("2C4RC1BG8ER138686")
        expect(@checker.recalls).to be_empty
      end
    end

    it "returns [] for real VIN 2C4RC1BG5ER268831 with no recalls" do
      VCR.use_cassette('chrysler', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chrysler.new("2C4RC1BG5ER268831")
        expect(@checker.recalls).to be_empty
      end
    end


    it "vin_invalid? for other company's VIN 1G1YM3D7XE5117202" do
      VCR.use_cassette('chrysler', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chrysler.new("1G1YM3D7XE5117202")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end