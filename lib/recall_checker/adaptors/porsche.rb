module RecallChecker
  module Adaptors
    class Porsche < Base
    	make 'porsche'
      base_uri 'http://recall.porsche.com/prod/pag/vinrecalllookup.nsf/GetVINResult'

      NBSP = "\u00a0"

      def options
        {query: {openagent: "", fin: @vin, language: "us"}}
      end

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(parsed_response)
      end

      def vin_invalid?
        @response.parsed_response.include? "the number you entered contains an error"
      end

      def recalls_html
        htmlpage.css('div.ps-ui-accordion-recalls').to_a
      end

      def retrieve_title item
        item.css('h3').text.split("\n")[0]
      end

      def retrieve_nhtsa_id item
        item.css('h3 span').text.split(NBSP + '|' + NBSP)[3].split(":" + NBSP)[1]
      end

      def retrieve_manufacturer_id item
        item.css('h3 span').text.split(NBSP + '|' + NBSP)[1]
      end

      def retrieve_description item
        item.css('div div')[0].text
      end

      def retrieve_risks item
        item.css('div div')[1].text
      end

      def retrieve_remedy item
        item.css('div div')[2].text
      end

      def retrieve_status item
        "Recall status information is not available"
      end

      def retrieve_notes item
        ""
      end

      def retrieve_created_at item
        item.css('h3 span').text.split(NBSP + '|' + NBSP)[2]
      end

      def retrieve_updated_at item
        item.css('div.row.text-right.show-grid-top').text.gsub("last updated","")
      end
    end
  end
end