module ProximityBeacon
  class AdvertisedId < GoogleResource
    camelcase_attr_accessor :type, :id

    def bytes
      @bytes ||= Base64.decode64(id)
    end

    def ids
      case type
      when "EDDYSTONE"
        [id_field(0..9), id_field(10..15)]
      when "IBEACON"
        [id_field(0..15), id_field(16..17), id_field(18..19)]
      when "ALTBEACON"
        [id_field(0..15), id_field(16..17), id_field(18..19)]
      end
    end

    def ibeacon_ids=(value)
      self.type = "IBEACON"
      uuid = value[0]
      major = value[1].to_i
      minor = value[2].to_i
      bytes = [uuid.gsub("-", "")].pack("H*") + [major].pack("S>") + [minor].pack("S>")
      self.id = Base64.strict_encode64(bytes)
    end

    def altbeacon_ids=(value)
      self.type = "ALTBEACON"
      uuid = value[0]
      major = value[1].to_i
      minor = value[2].to_i
      bytes = [uuid.gsub("-", "")].pack("H*") + [major].pack("S>") + [minor].pack("S>")
      self.id = Base64.strict_encode64(bytes)
    end

    def eddystone_ids=(value)
      self.type = "EDDYSTONE"
      namespace = value[0]
      instance = value[1]
      bytes = [namespace + instance].pack("H*")
      self.id = Base64.strict_encode64(bytes)
    end

    def beacon_type_code
      case type
      when "EDDYSTONE"
        3
      when "IBEACON"
        1
      when "ALTBEACON"
        5
      end
    end

    def to_beacon_name
      "beacons/#{beacon_type_code}!#{bytes.unpack("H*")[0]}"
    end

    def inspect
      "#<AdvertisedId type=#{type} ids=#{ids}>"
    end

  private

    def id_field(range)
      case
      when range.size >= 6
        bytes[range].unpack("H*")[0].upcase
      when range.size == 2
        bytes[range].unpack("S>")[0]
      when range.size == 4
        bytes[range].unpack("L>")[0]
      when range.size == 1
        bytes[range].unpack("C")[0]
      else
        bytes[range].unpack("H*")[0].upcase
      end
    end
  end
end
