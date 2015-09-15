module RecallChecker
  module Adaptors
    class Ford < Base
      make 'ford'
      # base_uri 'http://owner.ford.com/sharedServices/decodevin.do'
      base_uri 'http://owner.ford.com/sharedServices/recalls/query.do'

      def options
        {query: {country: 'USA', language: 'EN', vin: @vin}}
      end

      def matching_fields
        { title: "description_eng",
          date: "recall_date",
          refresh_date: "refresh_date",
          nhtsa_id: "nhtsa_recall_number",
          manufacturer_id: "mfr_recall_number",
          summary: "recall_description",
          safety_risk: "safety_risk_description",
          remedy: "remedy_description",
          status: "mfr_recall_status",
          manufacturer_notes: "mfr_notes" }
      end

      def add_items_to_recalls
        if (b = get_branch(parsed_response, "recalls"))
          b.each_value do |bv|
            recall = new_recall_record
            bv.each do |k,v|
              if matching_fields.has_value?(k)
                recall[matching_fields.key(k)] = v
              end
            end 
            @recalls << recall
          end
        end
      end

      def recalls
        if @recalls.nil?
          @recalls = []
          add_items_to_recalls
        end
        return @recalls
      end

    end
  end
end