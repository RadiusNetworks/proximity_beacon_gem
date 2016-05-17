module ProximityBeacon
  class Beacon < GoogleResource
    camelcase_attr_accessor :beacon_name, :advertised_id, :status, :description, :place_id, :lat_lng,
      :indoor_level, :expected_stability, :properties, :provisioning_key,
      :ephemeral_id_registration

    # convenience accessors
    alias_method :name, :beacon_name
    alias_method :name=, :beacon_name=

    def advertised_id=(value)
      if value.is_a? Hash
        @advertised_id = AdvertisedId.new(value)
      else
        @advertised_id = value
      end
    end

    def id
      name.split("/")[1]
    end

    def namespace
      advertised_id.ids[0]
    end

    def instance
      advertised_id.ids[1]
    end

    def inspect
      "#<Beacon name=\"#{name}\" description=\"#{description}\" advertised_id=#{advertised_id.inspect}>"
    end
  end
end
