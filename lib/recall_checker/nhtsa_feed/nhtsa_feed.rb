require 'httparty'

module RecallChecker
  class NHTSAFeed
    include HTTParty

    FIELDS = {
      "make" => "Make",
      "model" => "Model",
      "year" => "ModelYear",
      "component" => "Component",
      "manufacturer" => "Manufacturer",
      "created_at" => "ReportReceivedDate",
      "nhtsa_id" => "NHTSACampaignNumber",
      "description" => "Summary",
      "risks" => "Conequence",
      "remedy" => "Remedy",
      "notes" => "Notes"
    }
    
    def initialize start_date = (Time.now - (14*24*3600)).to_date
      @start_date = start_date
      @recalls_raw = {}
    end

    def feed_url
      "http://www-odi.nhtsa.dot.gov/rss/feeds/rss_recalls_V.xml"
    end

    def json_api_url nhtsa_id
      "http://www.nhtsa.gov/webapi/api/Recalls/vehicle/CampaignNumber/#{nhtsa_id}?format=json"
    end

    def feed
      @feed ||= self.class.get(feed_url).parsed_response['rss']['channel']['item']
    end

    def get_recalls_for_id nhtsa_id
      self.class.get(json_api_url nhtsa_id).parsed_response['Results']
    end

    def recalls_for_id nhtsa_id
      @recalls_raw[nhtsa_id] ||= get_recalls_for_id(nhtsa_id)
    end

    def feed_item_date item
      Date.parse(/Dated: (\w+ \w+, \w+)/.match(item['description'])[1])
    end

    def feed_nhtsa_ids
      feed
        .select { |x| feed_item_date(x) >= @start_date }
        .map { |x| /\( *([A-Z0-9]+) *\)/.match(x['guid']['__content__'])[1] }
        .uniq
    end

    def convert_values key, value
      case key
        when "created_at" then Time.at( /\(([0-9]+)-/.match(value)[1].to_i / 1000 )
        when "year" then value.to_i
        else value
      end
    end

    def convert_fields recall
      Hash[FIELDS.keys.map do |key|
        [ key, convert_values(key, recall[FIELDS[key]]) ]
      end]
    end

    def recalls
      feed_nhtsa_ids
        .map { |id| recalls_for_id(id) }
        .flatten
        .map { |x| convert_fields(x) }
    end

  end
end