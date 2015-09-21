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

      def recalls_raw
        htmlpage.css('div.ps-ui-accordion-recalls').to_a
      end

      def convert_title item
        item.css('h3').text.split("\n")[0]
      end

      def convert_nhtsa_id item
        item.css('h3 span').text.split(NBSP + '|' + NBSP)[3].split(":" + NBSP)[1]
      end

      def convert_manufacturer_id item
        item.css('h3 span').text.split(NBSP + '|' + NBSP)[1]
      end

      def convert_description item
        item.css('div div')[0].text
      end

      def convert_risks item
        item.css('div div')[1].text
      end

      def convert_remedy item
        item.css('div div')[2].text
      end

      def convert_status item
        "Recall status information is not available"
      end

      def convert_notes item
        ""
      end

      def convert_created_at item
        Time.parse(item.css('h3 span').text.split(NBSP + '|' + NBSP)[2])
      end

      def convert_updated_at item
        Time.parse(item.css('div.row.text-right.show-grid-top').text.gsub("last updated",""))
      end
    end
  end
end