require 'spec_helper'

describe RecallChecker::Adaptors::Ford do

    it "loads recall data for VIN 1ZVBP8AMXD5277023 with recalls" do
      VCR.use_cassette('ford', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("1ZVBP8AMXD5277023")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1

        r = @checker.recalls.first
        expect(r['title']).to eq "DRIVER AIRBAG INFLATOR REPLACEMENT"
        expect(r['created_at']).to eq Time.parse("27 May 2015")
        expect(r['nhtsa_id']).to eq "15V319"
        expect(r['manufacturer_id']).to eq "15S21"
        expect(r['description']).to start_with "IN THE SUBJECT VEHICLES"
        expect(r['risks']).to start_with "IN INFLATOR RUPTURE COULD RESULT"
        expect(r['remedy']).to start_with "DEALERS WILL REPLACE"
        expect(r['status']).to start_with "12 - RECALL INCOMPLETE"
        expect(r['notes']).to start_with "TO CHECK FOR NON-SAFETY-RELATED PROGRAMS"
      end
    end

    it "returns [] for real VIN 1FADP5AU9DL504830 with FSAs but no recalls" do
      VCR.use_cassette('ford', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("1FADP5AU9DL504830")
        expect(@checker.recalls).to be_empty
      end
    end

    it "returns [] for fake VIN 1ZVBP8AMXD5277000" do
      VCR.use_cassette('ford', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("1ZVBP8AMXD5277000")
        expect(@checker.recalls).to be_empty
      end
    end

end