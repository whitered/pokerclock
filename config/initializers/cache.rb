puts "#{__FILE__} contains monkeypatch! Don't forget to remove it when it is unnecessary."
module ActiveSupport
  module Cache
    class Entry
      def value
        if @value
          return @value.to_s if @value.is_a?(Hash)
          Marshal.load(compressed? ? Zlib::Inflate.inflate(@value) : @value)
        end
      end
    end
  end
end
