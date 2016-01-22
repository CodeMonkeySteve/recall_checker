module RecallChecker
  module Adaptors
    class Hyundai < Base
      make 'hyundai'
      base_uri 'https://autoservice.hyundaiusa.com/campaignhome'

      NBSP = "\u00a0"

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(response.parsed_response)
      end

      def vin_invalid?
        Nokogiri::HTML(@response.parsed_response).css('#lblmodelYear').text.strip.empty?
      end

      def recall_td recall, td_number
        r = recall.css('td')[td_number].text.split(':').last.gsub(NBSP,' ').strip
      end

      def recalls_html
        recalls_tr = htmlpage.css('#open-campaign-table tbody tr')
        if recalls_tr.text.include?("There are no open campaigns for this VIN") 
          []
        else 
          recalls_tr.select { |i| !recall_td(i,1).empty? }
        end
      end

      def retrieve_manufacturer_id item
        recall_td(item, 0).gsub("Campaign","")
      end

      def retrieve_nhtsa_id item
        recall_td(item, 1)
      end

      def retrieve_title item
        recall_td(item, 2)
      end

      def retrieve_description item
        recall_td(item, 2)
      end

      def retrieve_risks item
        recall_td(item, 3)
      end

      def retrieve_remedy item
        recall_td(item, 4)
      end

      def retrieve_status item
        recall_td(item, 5)
      end

      def retrieve_created_at item
        recall_td(item, 6)
      end
    end
  end
end