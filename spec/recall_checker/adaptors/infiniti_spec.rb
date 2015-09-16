require 'spec_helper'

describe RecallChecker::Adaptors::Infiniti do

    it "loads recall data for VIN JNKDA31A43T102555 with recalls" do
      VCR.use_cassette('infiniti', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Infiniti.new("JNKDA31A43T102555")
        expect(@checker.response).not_to be_empty
        expect(@checker.recalls.count).to eq 1
        expect(@checker.recalls.first['nhtsa_id']).to eq "14V-361"
        expect(@checker.recalls.first['created_at']).to eq Time.parse("25 AUG 2014 05:00:00")
      end
    end

    it "returns [] for fake VIN JNKDA31A43T102577" do
      VCR.use_cassette('infiniti', :record => :new_episodes) do
        @checker = RecallChecker::Adaptors::Ford.new("JNKDA31A43T102577")
        expect(@checker.recalls).to be_empty
      end
    end

end