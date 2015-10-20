require 'spec_helper'

describe RecallChecker::Adaptors::Mini do

    it "loads recall data for VIN WMWXM5C52ET935269 with recalls" do
      VCR.use_cassette('mini', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mini.new("WMWXM5C52ET935269")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 3

        r = @checker.recalls.select {|i| i['nhtsa_id'] == "14V-619"}.first # 3 recalls in the answer
        expect(r['title']).to start_with "SPARE WHEEL CARRIER"
        expect(r['created_at']).to eq Date.parse("2 Oct 2014")
        expect(r['nhtsa_id']).to eq "14V-619"
        expect(r['manufacturer_id']).to eq "NA"
        expect(r['description']).to start_with "On certain Model Year 2014 MINI Cooper Hardtop"
        expect(r['risks']).to start_with "If the space-saver spare wheel"
        expect(r['remedy']).to include "MINI dealer will replace"
        expect(r['status']).to eq "11"
        expect(r['notes']).to start_with "For additional information or assistance"
      end
    end

    it "returns [] for real VIN WMWZB3C54EWR39373 with no recalls" do
      VCR.use_cassette('mini', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mini.new("WMWZB3C54EWR39373")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN WMWZB3C54EWR30000" do
      VCR.use_cassette('mini', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mini.new("WMWZB3C54EWR30000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end