require 'spec_helper'

describe RecallChecker::Adaptors::JaguarLandRover do

    it "loads recall data for Jaguar VIN SAJWA4FB8ELB54506 with recalls" do
      VCR.use_cassette('jaguar_landrover', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Jaguar.new("SAJWA4FB8ELB54506")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "Jaguar Land Rover is conducting"
        expect(r['created_at']).to eq Time.parse("26 Jan 2015")
        expect(r['nhtsa_id']).to eq "15V-038"
        expect(r['manufacturer_id']).to eq "J049"
        expect(r['description']).to start_with "Jaguar Land Rover is conducting"
        expect(r['risks']).to start_with "A non-compliance concern has been identified"
        expect(r['remedy']).to start_with "Owners will be notified and instructed"
        expect(r['status']).to eq "Incomplete But Repair Available"
        expect(r['notes']).to eq ""

      end
    end

    it "loads recall data for Land Rover VIN SALWR2WF6EA330923 with 3 recalls" do
      VCR.use_cassette('jaguar_landrover', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::LandRover.new("SALWR2WF6EA330923")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 3
      end
    end

    it "returns [] for real Jaguar VIN SAJWA0FB6CLS35961 with no recalls" do
      VCR.use_cassette('jaguar_landrover', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Jaguar.new("SAJWA0FB6CLS35961")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN SAJWA0FB6CLS30000" do
      VCR.use_cassette('jaguar_landrover', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Jaguar.new("SAJWA0FB6CLS30000")
        expect(@checker.vin_invalid?).to eq true
      end
    end

end