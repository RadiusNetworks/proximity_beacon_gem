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
