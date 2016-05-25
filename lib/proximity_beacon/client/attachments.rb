module ProximityBeacon
  class Client
    class Attachments

      attr_accessor :credentials

      def initialize(credentials)
        self.credentials = credentials
      end

      def list(beacon_name, params = nil)
        uri = URI(PROXIMITY_BEACON_ROOT + beacon_name + "/attachments")
        response = Request.get(uri, credentials, params)
        json = JSON.parse(response.body)
        attachments_json = json["attachments"] || []
        attachments_json.map {|attachment_json| Attachment.new(attachment_json) }
      end

      def create(attachment, beacon_name, params = nil)
        uri = URI(PROXIMITY_BEACON_ROOT + beacon_name + "/attachments")
        response = Request.post(uri, credentials, params) { |request|
          request.body = attachment.to_json
          request.add_field "Content-Type", "application/json"
        }
        Attachment.new(JSON.parse(response.body))
      end

      def delete(attachment_name, params = nil)
        uri = URI(PROXIMITY_BEACON_ROOT + attachment_name)
        response = Request.delete(uri, credentials, params)
        JSON.parse(response.body)
      end

      def batch_delete(beacon_name, params = nil)
        uri = URI(PROXIMITY_BEACON_ROOT + beacon_name + "/attachments:batchDelete")
        response = Request.post(uri, credentials, params)
        JSON.parse(response.body)
      end
    end
  end
end
