require 'spec_helper'

describe RecallChecker::Adaptors::Mazda do

    it "loads recall data for VIN JM3TB28A380142569 with an open recall" do
      VCR.use_cassette('mazda_01', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mazda.new("JM3TB28A380142569")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "Water may enter the front suspension"
        expect(r['created_at']).to eq Date.parse("16 Jul 2015")
        expect(r['nhtsa_id']).to eq "15V-451"
        expect(r['manufacturer_id']).to eq "8515G"
        expect(r['description']).to start_with "Water may enter the front suspension"
        expect(r['risks']).to start_with "The vehicle may experience significant loss"
        expect(r['remedy']).to start_with "Dealers will inspect the lower control arm ball joints"
        expect(r['status']).to start_with "Recall Incomplete"
        expect(r['notes']).to eq nil
      end
    end

    it "returns [] for real VIN JM3TB2CA8F0451524 with no recalls" do
      VCR.use_cassette('mazda_02', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mazda.new("JM3TB2CA8F0451524")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for invalid VIN WDDLJ6FB8FA150000" do
      VCR.use_cassette('mazda_03', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mazda.new("WDDLJ6FB8FA150000")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end



end