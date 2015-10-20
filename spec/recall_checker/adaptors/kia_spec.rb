require 'spec_helper'

describe RecallChecker::Adaptors::Kia do

    it "loads recall data for VIN KNAFZ4A87E5050719 with a recall" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("KNAFZ4A87E5050719")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "IF THE COOLING FAN RESISTOR OVERHEATS"
        expect(r['created_at']).to eq Date.parse("2015-01-23")
        expect(r['nhtsa_id']).to eq "15V-015"
        expect(r['manufacturer_id']).to eq "SC113A"
        expect(r['description']).to start_with "KIA IS RECALLING CERTAIN MODEL"
        expect(r['risks']).to start_with "IF THE COOLING FAN RESISTOR OVERHEATS"
        expect(r['remedy']).to start_with "KIA WILL NOTIFY OWNERS"
        expect(r['status']).to eq "RECALL INCOMPLETE"
        expect(r['notes']).to eq ""
      end
    end

    it "loads recall data for VIN KNDJT2A27B7237019 with 2 recalls" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("KNDJT2A27B7237019")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end

    it "returns [] for real VIN KNAFZ6A39E5246452 with no recalls" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("KNAFZ6A39E5246452")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN 1G1YM3D7XE5117202" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("1G1YM3D7XE5117202")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end