module ProximityBeacon
  class Client
    class Projects

      CLOUD_RESOURCE_ROOT = "https://cloudresourcemanager.googleapis.com/v1beta1/"

      attr_accessor :credentials

      def initialize(credentials)
        self.credentials = credentials
      end

      def list(params = nil)
        uri = URI(CLOUD_RESOURCE_ROOT + "projects")
        response = Request.get(uri, credentials, params)
        json = JSON.parse(response.body)
        json["projects"].map {|project_json| Project.new(project_json) }
      end

    end
  end
end
