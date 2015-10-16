require 'spec_helper'

describe RecallChecker::Adaptors::Nissan do

    it "loads recall data for VIN 1N4AZ0CP6EC332264 with a recall" do
      VCR.use_cassette('nissan', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Nissan.new("1N4AZ0CP6EC332264")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1
        
        r = @checker.recalls.first
        expect(r['title']).to eq "OCCUPANT CLASS SYSTEM OCS"
        expect(r['created_at'].to_date).to eq Date.parse("10 APR 2014 05:00:00")
        expect(r['nhtsa_id']).to eq "14V-138"
        expect(r['manufacturer_id']).to eq "R1405"
        expect(r['description']).to start_with "In the affected vehicles"
        expect(r['risks']).to start_with "If the OCS does not detect an adult occupant"
        expect(r['remedy']).to start_with "Dealers will update the OCS software"
        expect(r['status']).to eq nil
        expect(r['notes']).to eq nil
      end
    end

    it "loads recall data for VIN 1N4AL3AP6DN408008 with 3 recalls" do
      VCR.use_cassette('nissan', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Nissan.new("1N4AL3AP6DN408008")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 3
      end
    end


    it "returns [] for real VIN 1N4AL3APXFC424372 with no recalls" do
      VCR.use_cassette('nissan', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Nissan.new("1N4AL3APXFC424372")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN 1N4AL3APXFC420000" do
      VCR.use_cassette('nissan', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Nissan.new("1N4AL3APXFC420000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end