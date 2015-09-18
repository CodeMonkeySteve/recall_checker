require 'spec_helper'

describe RecallChecker::Adaptors::Kia do

    it "loads recall data for VIN KNAFZ4A87E5050719 with recalls" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("KNAFZ4A87E5050719")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "IF THE COOLING FAN RESISTOR OVERHEATS"
        expect(r['created_at']).to eq Time.parse("2015-01-23 11:00:00")
        expect(r['nhtsa_id']).to eq "15V-015"
        expect(r['manufacturer_id']).to eq "SC113A"
        expect(r['description']).to start_with "KIA IS RECALLING CERTAIN MODEL"
        expect(r['risks']).to start_with "IF THE COOLING FAN RESISTOR OVERHEATS"
        expect(r['remedy']).to start_with "KIA WILL NOTIFY OWNERS"
        expect(r['status']).to eq "RECALL INCOMPLETE"
        expect(r['notes']).to eq ""
      end
    end

    it "returns [] for real VIN KNAFZ6A39E5246452 with no recalls" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("KNAFZ6A39E5246452")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN KNAFZ6A39E5200000" do
      VCR.use_cassette('kia', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Kia.new("KNAFZ6A39E5200000")
        expect(@checker.vin_invalid?).to eq true
      end
    end

end