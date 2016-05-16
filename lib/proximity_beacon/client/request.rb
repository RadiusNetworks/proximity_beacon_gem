require 'uri'
require 'net/http'
require 'base64'

module ProximityBeacon
  class Client
    class Request
      extend Forwardable

      attr_accessor :method, :uri, :credentials
      def_delegators :request, :add_field, :body=

      def self.get(uri, credentials = nil, params = nil)
        r = self.new(:get, uri, credentials, params)
        r.perform {|r| yield r if block_given? }
      end

      def self.post(uri, credentials = nil, params = nil)
        r = self.new(:post, uri, credentials, params)
        r.perform {|r| yield r if block_given? }
      end

      def self.put(uri, credentials = nil, params = nil)
        r = self.new(:put, uri, credentials, params)
        r.perform {|r| yield r if block_given? }
      end

      def self.delete(uri, credentials = nil, params = nil)
        r = self.new(:delete, uri, credentials, params)
        r.perform {|r| yield r if block_given? }
      end

      def initialize(method, uri, credentials = nil, params = nil)
        self.method = method
        if params
          url_params = params.map {|k,v| "#{k}=#{v}"}.join("&")
          self.uri = URI(uri + "?#{url_params}")
        else
          self.uri = uri
        end
        self.credentials = credentials
        yield self if block_given?
      end

      def perform
        http_opts = {use_ssl: true}
        response = Net::HTTP.start(uri.host, uri.port, http_opts) do |http|
          add_field "Authorization", "Bearer #{credentials.access_token}" if credentials
          add_field "Accept", "application/json"
          yield self if block_given?
          http.request request
        end
        if (200..299).include?(response.code.to_i)
          return response
        else
          raise RequestError.new(response.code.to_i), "Error #{response.code} (#{response.msg}) - #{uri}\n#{response.body}"
        end
      end

    private

      def request
        @request ||=
          begin
            case method
            when :get
              Net::HTTP::Get.new uri.request_uri
            when :post
              Net::HTTP::Post.new uri.request_uri
            when :put
              Net::HTTP::Put.new uri.request_uri
            when :delete
              Net::HTTP::Delete.new uri.request_uri
            end
          end
      end
    end

    class RequestError < StandardError
      attr_accessor :code
      def initialize(code)
        self.code = code
      end
    end

  end
end
