require 'json'
require 'uri'
require 'net/http'
require 'base64'
require 'forwardable'

require "proximity_beacon/version"
require "proximity_beacon/client"
require "proximity_beacon/client/beacons"
require "proximity_beacon/client/attachments"
require "proximity_beacon/client/projects"
require "proximity_beacon/client/request"
require "proximity_beacon/credentials"
require "proximity_beacon/oauth"
require "proximity_beacon/google_resource"
require "proximity_beacon/project"
require "proximity_beacon/beacon"
require "proximity_beacon/advertised_id"
require "proximity_beacon/attachment"

module ProximityBeacon
end
