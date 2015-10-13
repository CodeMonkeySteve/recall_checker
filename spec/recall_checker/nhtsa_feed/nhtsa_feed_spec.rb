require 'spec_helper'

describe RecallChecker::NHTSAFeed do

  before :each do
    @nhtsa_feed = RecallChecker::NHTSAFeed.new

    allow(@nhtsa_feed).to receive(:feed) do
      [ { "title"=>"BUICK  ( 15V599000 )", 
          "description"=>"Dated: SEP 23, 2015 General Motors LLC (GM) is recalling...", 
          "link"=>"http://www-odi.nhtsa.dot.gov/owners/SearchResults?searchType=ID&targetCategory=R&searchCriteria.nhtsa_ids=15V599000&refurl=rss", 
          "pubDate"=>"TUE, 13 OCT 2015 05:59:59 EST", 
          "guid"=>{"__content__"=>"BUICK  ( 15V599000 )", "isPermaLink"=>"false"} },
        { "title"=>"CHEVROLET  ( 15V599000 )", 
          "description"=>"Dated: SEP 23, 2015 General Motors LLC (GM) is recalling...", 
          "link"=>"http://www-odi.nhtsa.dot.gov/owners/SearchResults?searchType=ID&targetCategory=R&searchCriteria.nhtsa_ids=15V599000&refurl=rss", 
          "pubDate"=>"TUE, 13 OCT 2015 05:59:59 EST", 
          "guid"=>{"__content__"=>"CHEVROLET  ( 15V599000 )", "isPermaLink"=>"false"} },
        { "title"=>"FORD  ( 15V606000 )", 
          "description"=>"Dated: SEP 28, 2015 Ford Motor Company (Ford) is recalling...", 
          "link"=>"http://www-odi.nhtsa.dot.gov/owners/SearchResults?searchType=ID&targetCategory=R&searchCriteria.nhtsa_ids=15V606000&refurl=rss", 
          "pubDate"=>"TUE, 13 OCT 2015 05:59:59 EST", 
          "guid"=>{"__content__"=>"FORD  ( 15V606000 )", "isPermaLink"=>"false"} } ]
    end

    allow(@nhtsa_feed).to receive(:get_recalls_for_id) do |nhtsa_id|
      case nhtsa_id
      when "15V599000"
        [ 
          { "Manufacturer"=>"General Motors LLC", 
            "NHTSACampaignNumber"=>"15V599000", 
            "ReportReceivedDate"=>"/Date(1443067200000-0400)/", 
            "Component"=>"VISIBILITY:POWER WINDOW DEVICES AND CONTROLS", 
            "PotentialNumberofUnitsAffected"=>9932, 
            "Summary"=>"General Motors LLC (GM) is recalling certain model year", 
            "Conequence"=>"The protective coating may not eliminate the risk", 
            "Remedy"=>"GM will notify owners, and dealers will install", 
            "Notes"=>"Owners may also contact the National Highway Traffic Safety Administration", 
            "ModelYear"=>"2007", 
            "Make"=>"BUICK", 
            "Model"=>"RAINIER" },
          { "Manufacturer"=>"General Motors LLC", 
            "NHTSACampaignNumber"=>"15V599000", 
            "ReportReceivedDate"=>"/Date(1443067200000-0400)/", 
            "Component"=>"VISIBILITY:POWER WINDOW DEVICES AND CONTROLS", 
            "PotentialNumberofUnitsAffected"=>9932, 
            "Summary"=>"General Motors LLC (GM) is recalling certain model year", 
            "Conequence"=>"The protective coating may not eliminate the risk", 
            "Remedy"=>"GM will notify owners, and dealers will install", 
            "Notes"=>"Owners may also contact the National Highway Traffic Safety Administration", 
            "ModelYear"=>"2007", 
            "Make"=>"CHEVROLET", 
            "Model"=>"TRAILBLAZER" },
          { "Manufacturer"=>"General Motors LLC", 
            "NHTSACampaignNumber"=>"15V599000", 
            "ReportReceivedDate"=>"/Date(1443067200000-0400)/", 
            "Component"=>"VISIBILITY:POWER WINDOW DEVICES AND CONTROLS", 
            "PotentialNumberofUnitsAffected"=>9932, 
            "Summary"=>"General Motors LLC (GM) is recalling certain model year", 
            "Conequence"=>"The protective coating may not eliminate the risk", 
            "Remedy"=>"GM will notify owners, and dealers will install", 
            "Notes"=>"Owners may also contact the National Highway Traffic Safety Administration", 
            "ModelYear"=>"2007", 
            "Make"=>"GMC", 
            "Model"=>"ENVOY" }
        ]
      when "15V606000"
        [ 
          { "Manufacturer"=>"Ford Motor Company", 
            "NHTSACampaignNumber"=>"15V606000", 
            "ReportReceivedDate"=>"/Date(1443499200000-0400)/", 
            "Component"=>"POWER TRAIN:AUTOMATIC TRANSMISSION:GEAR POSITION INDICATION (PRNDL)", 
            "PotentialNumberofUnitsAffected"=>57, 
            "Summary"=>"Ford Motor Company (Ford) is recalling certain model year 2001-2008", 
            "Conequence"=>"If  the shift lever disengages from the transmission", 
            "Remedy"=>"Ford will notify owners, and dealers will inspect", 
            "Notes"=>"Owners may also contact the National Highway Traffic Safety Administration", 
            "ModelYear"=>"2008", 
            "Make"=>"FORD", 
            "Model"=>"ESCAPE" },
          { "Manufacturer"=>"Ford Motor Company", 
            "NHTSACampaignNumber"=>"15V606000", 
            "ReportReceivedDate"=>"/Date(1443499200000-0400)/", 
            "Component"=>"POWER TRAIN:AUTOMATIC TRANSMISSION:GEAR POSITION INDICATION (PRNDL)", 
            "PotentialNumberofUnitsAffected"=>57, 
            "Summary"=>"Ford Motor Company (Ford) is recalling certain model year 2001-2008", 
            "Conequence"=>"If  the shift lever disengages from the transmission", 
            "Remedy"=>"Ford will notify owners, and dealers will inspect", 
            "Notes"=>"Owners may also contact the National Highway Traffic Safety Administration", 
            "ModelYear"=>"2008", 
            "Make"=>"MERCURY", 
            "Model"=>"MARINER "},
          { "Manufacturer"=>"Ford Motor Company", 
            "NHTSACampaignNumber"=>"15V606000", 
            "ReportReceivedDate"=>"/Date(1443499200000-0400)/", 
            "Component"=>"POWER TRAIN:AUTOMATIC TRANSMISSION:GEAR POSITION INDICATION (PRNDL)", 
            "PotentialNumberofUnitsAffected"=>57, 
            "Summary"=>"Ford Motor Company (Ford) is recalling certain model year 2001-2008", 
            "Conequence"=>"If  the shift lever disengages from the transmission", 
            "Remedy"=>"Ford will notify owners, and dealers will inspect", 
            "Notes"=>"Owners may also contact the National Highway Traffic Safety Administration", 
            "ModelYear"=>"2007", 
            "Make"=>"FORD", 
            "Model"=>"ESCAPE" }
        ]
      else
        []
      end
    end
  end

  it "returns the recall data based on the feed" do
    expect(@nhtsa_feed.recalls.count).to eq 6
    r = @nhtsa_feed.recalls.select { |x| x['model'] == "RAINIER" }.first
    expect(r['make']).to eq "BUICK"
    expect(r['year']).to eq 2007
    expect(r['nhtsa_id']).to eq "15V599000"
    expect(r['description']).to start_with "General Motors LLC (GM) is recalling certain model"
    expect(r['risks']).to start_with "The protective coating may not eliminate the risk"
    expect(r['remedy']).to start_with "GM will notify owners"
    expect(r['notes']).to start_with "Owners may also contact"
  end
  
end

