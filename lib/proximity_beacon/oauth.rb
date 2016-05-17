require 'json'
require 'uri'
require 'net/http'

module ProximityBeacon
  class OAuth

    SCOPES = [
      "https://www.googleapis.com/auth/userlocation.beacon.registry",
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    REDIRECT_URI = "urn:ietf:wg:oauth:2.0:oob"
    TOKEN_URI = URI("https://www.googleapis.com/oauth2/v4/token")

    attr_accessor :client_id, :secret, :redirect_uri

    def initialize(redirect_uri = REDIRECT_URI, client_id = ENV["GOOGLE_CLIENT_ID"], secret = ENV["GOOGLE_CLIENT_SECRET"])
      if client_id.nil? || secret.nil?
        raise ArgumentError, "No Google Client ID or Secret was set. These can set in the environment variables \"GOOGLE_CLIENT_ID\" and \"GOOGLE_CLIENT_SECRET\" respectively. Credentials must be created for your project at \"https://console.developers.google.com/apis/credentials\"."
      end
      self.client_id = client_id
      self.secret = secret
      self.redirect_uri = redirect_uri
    end

    def get_code
      puts("Performing OAuth with Google...")
      if RUBY_PLATFORM =~ /darwin/
        system("open \"#{url}\"")
      else
        puts("Open this URL in your browser: \"#{url}\"\n\n")
      end
      printf "Copy and paste code from web browser here: "
      code = STDIN.gets.chomp
    end

    def get_credentials(code = nil)
      response = Client::Request.post(TOKEN_URI) {|request|
        request.body = hash_to_params(
          code: code || get_code,
          client_id: client_id,
          client_secret: secret,
          redirect_uri: redirect_uri,
          grant_type: "authorization_code",
        )
      }
      Credentials.new(JSON.parse(response.body))
    end

    def refresh_credentials(credentials)
      response = Client::Request.post(TOKEN_URI) {|request|
        request.body = hash_to_params(
          refresh_token: credentials.refresh_token,
          client_id: client_id,
          client_secret: secret,
          grant_type: "refresh_token",
        )
      }
      json = JSON.parse(response.body)
      new_credentials = Credentials.new(json)
      new_credentials.refresh_token = credentials.refresh_token
      new_credentials
    end

    def url
      params = hash_to_params(
        scope: SCOPES.join("%20"),
        redirect_uri: redirect_uri,
        response_type: "code",
        client_id: client_id,
      )
      "https://accounts.google.com/o/oauth2/v2/auth?#{params}"
    end

  private

    def hash_to_params(hash)
      hash.map {|k,v| "#{k}=#{v}"}.join("&")
    end

  end
end

