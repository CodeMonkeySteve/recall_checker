module RecallChecker
  module Adaptors
    class Hyundai < Base
    	make 'hyundai'
      base_uri 'https://autoservice.hyundaiusa.com/campaignhome'

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(response.parsed_response)
      end

      def vin_invalid?
      	Nokogiri::HTML(@response.parsed_response).css('#lblmodelYear').text.strip.empty?
      end

      def recall_td recall, td_number
      	recall.css('td')[td_number].text.split(':')[1].strip
      end

      def recalls_html
      	recalls_tr = htmlpage.css('#open-campaign-table tbody tr')
      	if recalls_tr.text.include?("There are no open campaigns for this VIN") 
      		[]
      	else 
      		recalls_tr.select { |i| recall_td(i,1) == "Recall" }
      	end
      end

      def retrieve_manufacturer_id item
      	recall_td(item, 0).gsub("Campaign","")
      end

      def retrieve_title item
      	recall_td(item, 2)
      end

      def retrieve_created_at item
      	recall_td(item, 3)
      end

      def convert_created_at time
      	DateTime.strptime(time + " " + Time.now.getlocal.zone, "%m/%d/%Y %Z").to_time
      end

      def convert_updated_at time
      end
    end
  end
end