require 'spec_helper'

describe RecallChecker::Adaptors::MercedesBenz do

    it "loads recall data for VIN WDDLJ7DB3EA107226 with an open recall" do
      VCR.use_cassette('mercedes_01', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::MercedesBenz.new("WDDLJ7DB3EA107226")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "218 SCN REAR SAM"
        expect(r['created_at']).to eq Date.parse("9 Mar 2015")
        expect(r['nhtsa_id']).to eq "15V137"
        expect(r['manufacturer_id']).to eq "2015030005"
        expect(r['description']).to start_with "Daimler AG (DAG), the manufacturer of Mercedes-Benz vehicles"
        expect(r['risks']).to start_with "Insufficient illumination levels in certain measuring points"
        expect(r['remedy']).to start_with "An authorized Mercedes-Benz dealer will update"
        expect(r['status']).to eq "Recall INCOMPLETE"
        expect(r['notes']).to eq nil
      end 
    end

    it "loads recall data for VIN WDDLJ9BB3EA095593 with 2 open recalls" do
      VCR.use_cassette('mercedes_02', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::MercedesBenz.new("WDDLJ9BB3EA095593")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end

    it "returns [] for real VIN WDDLJ9BB6EA123032 with closed recalls only" do
      VCR.use_cassette('mercedes_03', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::MercedesBenz.new("WDDLJ9BB6EA123032")
        expect(@checker.recalls).to be_empty
      end
    end

    it "returns [] for real VIN WDDLJ6FB8FA156009 with no recalls" do
      VCR.use_cassette('mercedes_04', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::MercedesBenz.new("WDDLJ6FB8FA156009")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for fake VIN WDDLJ6FB8FA150000" do
      VCR.use_cassette('mercedes_05', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::MercedesBenz.new("WDDLJ6FB8FA150000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end