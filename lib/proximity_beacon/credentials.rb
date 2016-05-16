require 'yaml'

module ProximityBeacon
  class Credentials

    DEFAULT_FILE_STORE = File.expand_path("~/.proximity_beacon_credentials.yaml")
    attr_accessor :access_token, :refresh_token, :expires_at

    def self.from_file(file = DEFAULT_FILE_STORE)
      return nil unless File.exist?(file)
      self.new YAML.load_file(file)
    end

    def initialize(opts = {})
      # convert string keys to symbols
      opts = opts.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

      self.access_token = opts[:access_token]
      self.refresh_token = opts[:refresh_token]
      self.expires_at = opts[:expires_at] || (Time.now + opts[:expires_in].to_i)
    end

    def save(file = DEFAULT_FILE_STORE)
      data = {
        access_token:  access_token,
        refresh_token: refresh_token,
        expires_at:    expires_at
      }.to_yaml
      File.open(file, 'w') {|f| f.write(data) }
    end

    def expired?
      self.expires_at < Time.now
    end

  end
end

