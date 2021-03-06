require 'spec_helper'

# tests for GM makes using Chevrolet VINS
describe RecallChecker::Adaptors::GMMakes do

    it "loads recall data for VIN 1G1YM3D7XE5117135 with a recall" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("1G1YM3D7XE5117135")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "FUEL FILL PIPE ANTI-SIPHON GRID OUT OF POSITION"
        expect(r['created_at']).to eq Date.parse("2014-12-19")
        # expect(r['nhtsa_id']).to eq "14V346"
        # expect(r['manufacturer_id']).to eq "N140294"
        # expect(r['description']).to start_with "General Motors has decided"
        # expect(r['risks']).to start_with "The timing of the key movement"
        # expect(r['remedy']).to start_with "Dealers are to provide"
        # expect(r['status']).to eq "11"
        # expect(r['notes']).to eq nil
      end
    end

    it "loads recall data for VIN 1G1YM3D7XE5117202 with 2 recalls" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("1G1YM3D7XE5117202")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 2
      end
    end


    it "returns [] for real VIN 2G1FT3DW8E9240520 with no recalls" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("2G1FT3DW8E9240520")
        expect(@checker.recalls).to be_empty
      end
    end

    it "vin_invalid? for other company's VIN 1N4AL3AP6DN408008" do
      VCR.use_cassette('chevrolet', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Chevrolet.new("1N4AL3AP6DN408008")
        expect { @checker.recalls }.to raise_error RecallChecker::VinError
      end
    end

end