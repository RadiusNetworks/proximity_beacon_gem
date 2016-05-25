module ProximityBeacon
  class GoogleResource

    def self.camelcase_attr_accessor(*accessors)
      accessors.each do |accessor|
        attr_accessor accessor
        alias_camelized_accessor(accessor)
      end
    end

    def initialize(hash = {})
      hash.each do |key, value|
        writer = "#{key}="
        self.send(writer, value) if respond_to?(writer)
      end
    end

    def update(hash)
      hash.each do |key, value|
        self.send "#{key}=", value
      end
    end

    def as_json
      Hash[
        self.class.json_attrs.map {|attr|
          value = send(attr)
          if value.nil?
            nil
          elsif value.is_a? GoogleResource
            [attr, value.as_json]
          else
            [attr, value]
          end
        }.compact
      ]
    end

    def to_json
      as_json.to_json
    end

  private

    class << self
      attr_accessor :json_attrs
    end


    def self.alias_camelized_accessor(accessor)
      self.json_attrs ||= []
      camelized_accessor = camelize(accessor)
      if camelized_accessor
        define_method(camelized_accessor) { send(accessor) }
        define_method("#{camelized_accessor}=") {|value| send("#{accessor}=", value) }
        json_attrs << camelized_accessor
      else
        json_attrs << accessor.to_s
      end
    end

    def self.camelize(string)
      words = string.to_s.split("_")
      return nil if words.count == 1
      words[0] + words[1..-1].map(&:capitalize).join
    end
  end
end
