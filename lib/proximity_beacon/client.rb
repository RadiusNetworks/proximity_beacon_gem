module ProximityBeacon
  class Client

    PROXIMITY_BEACON_ROOT = "https://proximitybeacon.googleapis.com/v1beta1/"

    attr_accessor :credentials

    def initialize(credentials = nil)
      if credentials.nil?
        # if no credentials are provided, we try to load them from file or
        # initiate a CLI based oauth flow
        self.credentials = Credentials.from_file || OAuth.new.get_credentials
        if self.credentials.expired? && self.credentials.refresh_token
          self.credentials = OAuth.new.refresh_credentials(self.credentials)
        end
        self.credentials.save
      else
        self.credentials = credentials
      end
    end

    def eidparams
      uri = URI(PROXIMITY_BEACON_ROOT + "eidparams")
      response = Request.get(uri, credentials)
      return JSON.parse(response.body)
    end

    def projects
      Projects.new(credentials)
    end

    def beacons
      Beacons.new(credentials)
    end

    def attachments
      Attachments.new(credentials)
    end

    def getforobserved(eids, api_key = ENV["GOOGLE_API_KEY"])
      uri = URI("#{PROXIMITY_BEACON_ROOT}beaconinfo:getforobserved?key=#{api_key}")
      response = Request.post(uri) {|request|
        observations = Array(eids).map {|eid|
          {advertisedId: {type: "EDDYSTONE_EID", id: base64_eid(eid)}}
        }
        request.body = {
          observations: observations,
          namespacedTypes: "*",
        }.to_json
        request.add_field "Content-Type", "application/json"
      }
      JSON.parse(response.body)
    end

  private

    def base64_eid(eid)
      if eid.size == 16
        Base64.strict_encode64([eid].pack("H*"))
      else
        Base64.strict_encode64(eid)
      end
    end

  end
end
