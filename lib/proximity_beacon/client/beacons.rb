module ProximityBeacon
  class Client
    class Beacons

      BEACONS_URI = URI(PROXIMITY_BEACON_ROOT + "beacons")

      attr_accessor :credentials

      def initialize(credentials)
        self.credentials = credentials
      end

      def list(params = {pageSize: 1000})
        response = Request.get(BEACONS_URI, credentials, params)
        json = JSON.parse(response.body)
        beacons_json = json["beacons"] || []
        beacons_json.map {|beacon_json| Beacon.new(beacon_json) }
      end

      def get(beacon_name, params = nil)
        uri = URI(Client::PROXIMITY_BEACON_ROOT + beacon_name)
        response = Request.get(uri, credentials, params)
        json = JSON.parse(response.body)
        Beacon.new(json)
      end

      def register(beacon, params = nil)
        uri = URI(Client::PROXIMITY_BEACON_ROOT + "beacons:register")
        response = Request.post(uri, credentials, params) { |request|
          request.body = beacon.to_json
          request.add_field "Content-Type", "application/json"
        }
        Beacon.new(JSON.parse(response.body))
      end

      def update(beacon, params = nil)
        uri = URI(Client::PROXIMITY_BEACON_ROOT + beacon.name)
        response = Request.put(uri, credentials, params) { |request|
          request.body = beacon.to_json
          request.add_field "Content-Type", "application/json"
        }
        json = JSON.parse(response.body)
        Beacon.new(json)
      end
    end
  end
end
