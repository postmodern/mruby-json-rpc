module JSON
  module RPC
    module Request
      def self.parse(json)
        json = JSON.parse(json)

        if json.class == Array
          V2::Request::Batch.new(json)
        elsif json.class == Hash && !json.has_key?('jsonrpc')
          V1::Request.new(json)
        else
          V2::Request.new(json)
        end
      end
    end
  end
end
