require 'spec_helper'

describe RecallChecker::Adaptors::Honda do

    it "loads recall data for VIN 19XFB2F56EE264518 with recalls" do
      VCR.use_cassette('honda', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Honda.new("19XFB2F56EE264518")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "M-CVT DRIVE PULLEY SHAFT"
        expect(r['created_at']).to eq Date.parse("4 Sep 2015")
        expect(r['nhtsa_id']).to eq "AWAITING#"
        expect(r['manufacturer_id']).to eq "JU2"
        expect(r['description']).to eq ""
        expect(r['risks']).to eq ""
        expect(r['remedy']).to eq ""
        expect(r['status']).to eq "Recall INCOMPLETE"
        expect(r['notes']).to eq nil

      end
    end

    it "returns [] for real VIN 1HGCR6F39FA002955 with no recalls" do
      VCR.use_cassette('honda', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Honda.new("1HGCR6F39FA002955")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN 1N4AL3AP6DN408008" do
      VCR.use_cassette('honda', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Honda.new("1N4AL3AP6DN408008")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end