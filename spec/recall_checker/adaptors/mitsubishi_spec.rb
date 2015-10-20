require 'spec_helper'

describe RecallChecker::Adaptors::Mitsubishi do

    it "loads recall data for VIN JA3215H17CU014800 with a recall" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("JA3215H17CU014800")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to start_with "DUE TO EITHER OF THE FOLLOWING REASONS"
        expect(r['created_at']).to eq Date.parse("29 Aug 2014")
        expect(r['nhtsa_id']).to eq "14V522"
        expect(r['manufacturer_id']).to eq "SR-14-007"
        expect(r['description']).to start_with "DUE TO EITHER OF THE FOLLOWING REASONS"
        expect(r['risks']).to start_with "BRAKE VACUUM PUMP INOPERABILITY"
        expect(r['remedy']).to start_with "THE DEALERSHIP WILL REPROGRAM"
        expect(r['status']).to eq "Recall status information is not available"
        expect(r['notes']).to eq nil
      end
    end

    it "loads recall data for VIN 4A4AP5AU3DE022512 2 recalls" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("4A4AP5AU3DE022512")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end


    it "returns [] for real VIN JA4AZ3A32GZ004183 with no recalls" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("JA4AZ3A32GZ004183")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN 1G1YM3D7XE5117202" do
      VCR.use_cassette('mitsubishi', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Mitsubishi.new("1G1YM3D7XE5117202")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end