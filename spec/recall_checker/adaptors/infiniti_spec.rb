require 'spec_helper'

describe RecallChecker::Adaptors::Infiniti do

    it "loads recall data for VIN JNKDA31A43T102555 with recalls" do
      VCR.use_cassette('infiniti', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Infiniti.new("JNKDA31A43T102555")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1
        
        r = @checker.recalls.first
        expect(r['title']).to eq "PASSENGER AIR BAG INFLATOR"
        expect(r['created_at']).to eq Date.parse("25 AUG 2014 05:00:00")
        expect(r['nhtsa_id']).to eq "14V-361"
        expect(r['manufacturer_id']).to eq "R1406"
        expect(r['description']).to start_with "Infiniti was notified by its supplier"
        expect(r['risks']).to start_with "If a vehicle with an affected air bag"
        expect(r['remedy']).to start_with "Your dealer will replace"
        expect(r['status']).to eq nil
        expect(r['notes']).to eq nil
      end
    end

    it "returns [] for real VIN JN1CV6AP9FM501289 with no recalls" do
      VCR.use_cassette('infiniti', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Infiniti.new("JN1CV6AP9FM501289")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN JN1CV6AP9FM500000" do
      VCR.use_cassette('infiniti', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Infiniti.new("JN1CV6AP9FM500000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end