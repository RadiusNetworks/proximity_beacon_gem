module ProximityBeacon
  class Attachment < GoogleResource
    camelcase_attr_accessor :attachment_name, :namespaced_type, :data

    # convenience accessors
    alias_method :name, :attachment_name
    alias_method :name=, :attachment_name=

    def initialize(*args)
      self.namespaced_type = ""
      super
    end

    def namespace
      namespaced_type.split("/")[0]
    end

    def namespace=(value)
      self.namespaced_type = [value, (type || "")].join("/")
    end

    def type
      namespaced_type.split("/")[1]
    end

    def type=(value)
      self.namespaced_type = [(namespace || ""), value].join("/")
    end

    def decoded_data
      Base64.decode64(data)
    end

    def decoded_data=(value)
      self.data = Base64.strict_encode64(value)
    end

    def id
      name.split("/").last
    end

    def inspect
      "#<Attachment name=\"#{name}\" namespaced_type=\"#{namespace}/#{type}\">"
    end
  end
end
