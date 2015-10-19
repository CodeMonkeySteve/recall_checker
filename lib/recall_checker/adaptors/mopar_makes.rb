module RecallChecker
  module Adaptors
    class MoparMakes < Base
      base_uri 'http://www.moparownerconnect.com/oc/us/en-us/sub/Pages/RecallsResults.aspx'

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(parsed_response)
      end

      def vin_invalid?
        @response.parsed_response.include? "is not a valid VIN.<br"
      end

      def recalls_html
        r = htmlpage.css('#divSafetyRecallsTable tr').drop(1).to_a
        r.select { |i| recall_item_incomplete?(i) }
      end

      def recall_item_incomplete? item
        item.css('td')[0].inner_html.include? '/incomplete.png'
      end
    
      def retrieve_title item
        retrieve_description item # no separate title available
      end

      def retrieve_nhtsa_id item
        item.css('td')[3].text
      end

      def retrieve_manufacturer_id item
        item.css('td')[2].css('a').text
      end

      def retrieve_description item
        item.css('td')[5].text
      end

      def retrieve_risks item
        retrieve_description item # no separate risk description available
      end

      def retrieve_remedy item
        item.css('td')[6].text
      end

      def retrieve_status item
        item.css('td')[7].text
      end

      def retrieve_created_at item
        item.css('td')[4].text
      end

      def retrieve_updated_at item
        htmlpage.css('#divLastResults').text.split(':')[1].strip
      end
    end

    class Chrysler < MoparMakes
      make 'chrysler'
    end

    class Dodge < MoparMakes
      make 'dodge'
    end

    class Fiat < MoparMakes
      make 'fiat'
    end

    class Jeep < MoparMakes
      make 'jeep'
    end

    class AlfaRomeo < MoparMakes
      make 'alfaromeo'
    end

    class Ram < MoparMakes
      make 'ram'
    end

  end
end