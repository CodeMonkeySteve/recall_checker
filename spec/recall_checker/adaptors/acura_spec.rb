require 'spec_helper'

describe RecallChecker::Adaptors::Acura do

    it "loads recall data for VIN 5FRYD4H41FB013225 with a recall" do
      VCR.use_cassette('acura', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Acura.new("5FRYD4H41FB013225")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "A/C Compressor Clutch Bolt"
        expect(r['created_at']).to eq Date.parse("24 Jun 2015")
        expect(r['nhtsa_id']).to eq "15V-417"
        expect(r['manufacturer_id']).to eq "JQ7"
        expect(r['description']).to start_with "AMERICAN HONDA MOTOR CO"
        expect(r['risks']).to start_with "EITHER OF THESE CONDITIONS"
        expect(r['remedy']).to start_with "HONDA WILL NOTIFY OWNERS"
        expect(r['status']).to eq "Recall INCOMPLETE"
        expect(r['notes']).to eq nil
      end
    end

    it "loads recall data for VIN JH4CL96847C009863 with 2 recalls" do
      VCR.use_cassette('acura', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Acura.new("JH4CL96847C009863")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end


    it "returns [] for real VIN 5FRYD4H25FB015560 with no recalls" do
      VCR.use_cassette('acura', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Acura.new("5FRYD4H25FB015560")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN WMWXM5C52ET935269" do
      VCR.use_cassette('acura', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Acura.new("WMWXM5C52ET935269")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end