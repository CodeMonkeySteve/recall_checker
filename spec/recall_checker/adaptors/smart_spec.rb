require 'spec_helper'

describe RecallChecker::Adaptors::Smart do

    it "loads recall data for VIN WMEEJ3BA5EK770413 with recalls" do
      VCR.use_cassette('smart', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Smart.new("WMEEJ3BA5EK770413")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "STEER BOLT"
        expect(r['created_at']).to eq Time.parse("27 Mar 2015")
        expect(r['nhtsa_id']).to eq "15V192"
        expect(r['manufacturer_id']).to eq "2015040002"
        expect(r['description']).to start_with "Daimler AG (DAG), the manufacturer of smart vehicles"
        expect(r['risks']).to start_with "These bolts might break during the lifetime"
        expect(r['remedy']).to start_with "An authorized smart dealer will replace"
        expect(r['status']).to eq "Recall INCOMPLETE"
        expect(r['notes']).to eq ""

      end
    end

    it "returns [] for real VIN WMEEJ9AA9EK743364 with no recalls" do
      VCR.use_cassette('smart', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Smart.new("WMEEJ9AA9EK743364")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN WMEEJ9AA9EK740000" do
      VCR.use_cassette('smart', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Smart.new("WMEEJ9AA9EK740000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end
end