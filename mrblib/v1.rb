module JSON
  module RPC
    module V1
      #
      # A JSON-RPC 1.0 request.
      #
      class Request

        #
        # Initializes the JSON-RPC 1.0 request.
        #
        # @param [Hash] json
        #   The parsed JSON.
        #
        def initialize(json)
          @json = json
        end

        #
        # The method to call.
        #
        # @return [String]
        #
        def method
          @json['method']
        end

        #
        # The params of the request.
        #
        # @return [Array]
        #
        def params
          @json['params']
        end

        #
        # The id of the request.
        #
        # @return [Object]
        #
        def id
          @json['id']
        end

        #
        # Validates the JSON-RPC 1.0 request.
        #
        # @return [Boolean]
        #
        def valid?
          unless @json.class == Hash
            return false
          end

          unless @json['method'].class == String
            return false
          end

          unless @json['params'].class == Array
            return false
          end

          return true
        end

        #
        # Determines if the request is a notification.
        #
        # @return [Boolean]
        #   Specifies whether the request is a notification or a method call.
        #
        def notification?
          @json['id'].nil?
        end

      end

      #
      # Represents JSON-RPC 1.0 responses.
      #
      module Responses

        def self.result(result,id)
          {
            'result' => result,
            'error'  => nil,
            'id'     => id
          }
        end

        def self.error(error,id=nil)
          {
            'result' => nil,
            'error'  => error,
            'id'     => id
          }
        end

      end
    end
  end
end
