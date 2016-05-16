require 'spec_helper'

module ProximityBeacon
  describe GoogleResource do
    let(:foo) {
      class Foo < GoogleResource
        camelcase_attr_accessor :foo_bar
      end
      Foo.new
    }

    it 'adds camelcase accessors' do
      foo.foo_bar = "bar"
      expect(foo.fooBar).to eq("bar")
    end

    it "produces json with the camelized accessors" do
      foo.foo_bar = "bar"
      expect(foo.as_json).to eq({"fooBar" => "bar"})
    end
  end
end
