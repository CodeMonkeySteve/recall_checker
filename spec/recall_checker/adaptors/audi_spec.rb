require 'spec_helper'

describe RecallChecker::Adaptors::Audi do

    it "loads recall data for VIN WAUAFAFL9DA143522 with recalls" do
      VCR.use_cassette('audi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Audi.new("WAUAFAFL9DA143522")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "Airbag Control Unit Deployment Parameter"
        expect(r['created_at']).to eq Date.parse("24 Oct 2014")
        expect(r['nhtsa_id']).to eq "14V667"
        expect(r['manufacturer_id']).to eq "69K5"
        expect(r['description']).to start_with "In rare cases, it is possible"
        expect(r['risks']).to start_with "Front seat occupants may not have"
        expect(r['remedy']).to start_with "To correct this defect"
        expect(r['status']).to eq "11"
        expect(r['notes']).to eq " "
      end
    end

    it "returns [] for real VIN WAUEFGFF8F1055031 with no recalls" do
      VCR.use_cassette('audi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Audi.new("WAUEFGFF8F1055031")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN WMWXM5C52ET935269" do
      VCR.use_cassette('audi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Audi.new("WMWXM5C52ET935269")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end