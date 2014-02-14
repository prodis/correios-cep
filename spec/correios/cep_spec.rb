require 'spec_helper'

describe Correios::CEP do
  describe "#request_timeout" do
    it "default is 5" do
      Correios::CEP.request_timeout.should eql 5
    end

    context "when set timeout" do
      it "returns timeout" do
        Correios::CEP.configure { |config| config.request_timeout = 3 }
        Correios::CEP.request_timeout.should eql 3
      end

      it "returns timeout in seconds (integer)" do
        Correios::CEP.configure { |config| config.request_timeout = 2.123 }
        Correios::CEP.request_timeout.should eql 2
      end
    end
  end
end

