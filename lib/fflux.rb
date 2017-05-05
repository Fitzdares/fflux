require "fflux/version"
require 'socket'

module Fflux

  class << self

    @@port = 4444
    @@host = '127.0.0.1'

    def write(measurement, values = {}, tags = {})
      Thread.new do
        socket = UDPSocket.new
        socket.send(
          payload(measurement, values, tags),
          0,
          @@host,
          @@port
        )
      end
    end

    def setup
      yield self
    end

    def port=(port)
      @@port = port
    end

    def host=(host)
      @@host = host
    end

    private

    def payload(measurement, values, tags)
      [
        key(measurement, tags),
        fields(values),
      ].compact.join(" ") + "\n"
    end

    def fields(values)
      format(values, :format_value)
    end

    def format_value(value)
      case value
      when String
        "\"#{value}\""
      when Fixnum
        "#{value}i"
      else
        value.to_s
      end
    end

    def key(measurement, tags)
      [
        escape(measurement),
        format(tags)
      ].compact.join(",")
    end

    def escape(value)
      value
        .to_s
        .gsub(",", "\,")
        .gsub(" ", "\ ")
        .gsub(/(.)"(.)/, '\1\"\2')
    end

    def format(tags, processor = :escape)
      return unless tags.any?
      tags.map { |k,v| "#{escape(k)}=#{send(processor, v)}" }.join(",")
    end

  end

end
