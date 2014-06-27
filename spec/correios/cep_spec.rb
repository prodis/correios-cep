require 'spec_helper'

describe Correios::CEP do
  describe "#request_timeout" do
    it "default is 5" do
      expect(Correios::CEP.request_timeout).to eql 5
    end

    context "when set timeout" do
      it "returns timeout" do
        Correios::CEP.configure { |config| config.request_timeout = 3 }
        expect(Correios::CEP.request_timeout).to eql 3
      end

      it "returns timeout in seconds (integer)" do
        Correios::CEP.configure { |config| config.request_timeout = 2.123 }
        expect(Correios::CEP.request_timeout).to eql 2
      end
    end
  end
end

