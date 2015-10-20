require 'spec_helper'

describe RecallChecker::Adaptors::BMW do

    it "loads recall data for VIN WBA3C3C51EF986010 with a recall" do
      VCR.use_cassette('bmw', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::BMW.new("WBA3C3C51EF986010")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "FRONT SIDE MARKER LAMPS"
        expect(r['created_at']).to eq Date.parse("13 Aug 2015")
        expect(r['nhtsa_id']).to eq "15V-520"
        expect(r['manufacturer_id']).to eq "NA"
        expect(r['description']).to start_with "Your vehicle was updated"
        expect(r['risks']).to start_with "Your vehicle does not conform"
        expect(r['remedy']).to start_with "Your BMW center will reprogram"
        expect(r['status']).to eq "11"
        expect(r['notes']).to start_with "For additional information or assistance"
      end
    end

    it "loads recall data for VIN WBANU53538CT12139 with 2 recalls" do
      VCR.use_cassette('bmw', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::BMW.new("WBANU53538CT12139")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end


    it "returns [] for real VIN WBA3N9C55FK248054 with no recalls" do
      VCR.use_cassette('bmw', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::BMW.new("WBA3N9C55FK248054")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN 1N4AL3AP6DN408008" do
      VCR.use_cassette('bmw', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::BMW.new("1N4AL3AP6DN408008")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end