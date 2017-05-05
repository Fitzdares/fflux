require "spec_helper"
require 'socket'

RSpec.describe Fflux do
  let(:test_socket) { double }

  before do
    allow(UDPSocket).to receive(:new) { test_socket }
  end

  it "has a version number" do
    expect(Fflux::VERSION).not_to be nil
  end

  describe '.write' do

    it 'writes measurement only correctly' do
      expect_udp_content("cpu\n")
      Fflux.write("cpu").join
    end

    it 'writes measurement with tags correctly' do
      expect_udp_content("cpu,host=serverA,region=us-west\n")
      Fflux.write("cpu", {}, { host: "serverA", region: "us-west" }).join
    end

    it 'writes measurement with commas correctly' do
      expect_udp_content("cpu\,01,host=serverA,region=us-west\n")
      Fflux.write("cpu,01", {}, { host: "serverA", region: "us-west" }).join
    end

    it 'writes tag value with spaces correctly' do
      expect_udp_content("cpu,host=server\ A,region=us\ west\n")
      Fflux.write("cpu", {}, { host: "server A", region: "us west" }).join
    end

    it 'writes integer values correctly' do
      expect_udp_content("cpu value=1i\n")
      Fflux.write("cpu", { value: 1 }).join
    end

    it 'writes float values correctly' do
      expect_udp_content("cpu_load value=1.2\n")
      Fflux.write("cpu_load", { value: 1.2 }).join
    end

    it 'writes boolean values correctly' do
      expect_udp_content("error fatal=true,propagate=false\n")
      Fflux.write("error", { fatal: true, propagate: false }).join
    end

    it 'writes string values correctly' do
      expect_udp_content('event message="just testing"' + "\n")
      Fflux.write("event", { message: 'just testing' }).join
    end

    it 'writes a full example correctly' do
      expect_udp_content("cpu\ 0\,1,host=Server\ A,regions=eu\,us idle=22.0,extended=true,description=\"Intel Thing\"\n")
      Fflux.write("cpu 0,1", { idle: 22.0, extended: true, description: "Intel Thing" }, { host: "Server A", regions: "eu,us" }).join
    end

  end

  private

  def expect_udp_content(content)
    expect(test_socket).to receive(:send).with(content, 0, '127.0.0.1', 8092)
  end

end
