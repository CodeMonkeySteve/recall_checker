module RecallChecker
  module Adaptors
    class Mazda < Base
    	make 'mazda'
      base_uri 'http://www.mazdausa.com/MusaWeb/displayRecallOwners.action'

      NBSP = "\u00a0"

      def options
        { body: { 'vin' => @vin } }
      end

      def request
        self.class.post(url, options)
      end

      def vin_invalid?
        p = Nokogiri::HTML(@response.parsed_response.split("<!-- No Recalls Present -->")[1]).css(".recall_error")
        p.text.include? "The VIN you entered is invalid"
      end

      def htmlpage
        @htmlpage ||= Nokogiri::HTML(parsed_response)
      end

      def recalls_html
        rec_ids = htmlpage.css('#recallResult div.recall_row.recall_info').to_a
        rec_desc = htmlpage.css('#recallResult div.recall_row.table_container').to_a
        raise MalformedDataError if rec_ids.count != rec_desc.count 
        rec_ids.map.with_index { |r,i| Nokogiri::HTML(r.to_html + rec_desc[i].to_html) }
      end

      def retrieve_title item
        retrieve_description(item).split('.')[0]
      end

      def retrieve_nhtsa_id item
        item.css('.recall_info').text.strip.split("\n")[2].split(":")[1].strip
      end

      def retrieve_manufacturer_id item
        item.css('.recall_info').text.strip.split("\n")[0].split(":")[1].strip
      end

      def retrieve_description item
        item.css('.table_container .tableElement')[1].text.split("Safety Risk:")[0].strip
      end

      def retrieve_risks item
        item.css('.table_container .tableElement')[1].text.split("Safety Risk:")[1].strip
      end

      def retrieve_remedy item
        item.css('.table_container .tableElement')[2].text.strip
      end

      def retrieve_status item
        item.css('.table_container .tableElement')[3].text.strip
      end

      def retrieve_created_at item
        item.css('.table_container .tableElement')[0].text.strip
      end

      def retrieve_updated_at item
        htmlpage.css('.recall_row p b').text.split("\n")[0].gsub("Last Updated:","").strip
      end

      def convert_created_at time
        DateTime.strptime(time + " " + Time.now.getlocal.zone, "%m/%d/%y %Z").to_time
      end

    end
  end
end