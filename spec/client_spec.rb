require 'spec_helper'

module ProximityBeacon
  describe Client do
    let(:credentials) {
      Credentials.new(
        access_token: "TOKEN",
        refresh_token: "REFRESH",
        expires_at: Time.now + (5*60)
      )
    }

    it "can be initialized with credentials" do
      client = Client.new(credentials)
      expect(client.credentials).to be(credentials)
    end

    context "given valid credentials" do
      let(:client) { Client.new(credentials) }
      it "has a beacons endpoint" do
        expect(client.beacons).to be_an_instance_of(Client::Beacons)
      end
      it "has an attachments endpoint" do
        expect(client.attachments).to be_an_instance_of(Client::Attachments)
      end
      it "has a projects endpoint" do
        expect(client.projects).to be_an_instance_of(Client::Projects)
      end
    end
  end
end
