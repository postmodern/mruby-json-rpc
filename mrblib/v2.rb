module JSON
  module RPC
    module V2
      #
      # A JSON-RPC 2.0 request.
      #
      class Request < V1::Request

        VERSION = '2.0'

        #
        # Represents a batch request.
        #
        class Batch

          include Enumerable

          #
          # Initializes the batch request.
          #
          # @param [Array<Hash>] json
          #   The parse JSON.
          #
          def initialize(json)
            @requests = json.map { |hash| Request.new(hash) }
          end

          #
          # Enumerates over each request in the batch.
          #
          # @yield [request]
          #   The given block will be passed each request.
          # 
          # @yieldparam [Request] request
          #   A request within the batch.
          #
          # @return [self]
          #
          def each(&block)
            @requests.each(&block)
            return self
          end

          #
          # Determines whether the batch request is valid.
          #
          # @return [Boolean]
          #
          def valid?
            !@requests.empty?
          end

        end

        #
        # Initializes the JSON-RPC 2.0 request.
        #
        # @param [Hash] json
        #   The parsed JSON.
        #
        def initialize(json)
          @json = json
        end

        #
        # The `jsonrpc` version field.
        #
        # @return ["2.0"]
        #
        def jsonrpc
          @json['jsonrpc']
        end

        #
        # Validates the JSON-RPC 2.0 request.
        #
        # @return [Boolean]
        #
        def valid?
          unless @json.class == Hash
            return false
          end

          unless @json['jsonrpc'] == VERSION
            return false
          end

          unless @json['method'].class == String
            return false
          end

          unless (!@json.has_key?('params')
                   @json['params'].class == Array ||
                   @json['params'].class == Hash)
            return false
          end

          unless (!@json.has_key?('id') ||
                   @json['id'].class == String ||
                   @json['id'].class == Fixnum)
            return false
          end

          return true
        end

        #
        # Determines if the request is a notification.
        #
        # @return [Boolean]
        #
        def notification?
          !@json.has_key?('id')
        end

      end

      #
      # Represents JSON-RPC 2.0 responses.
      #
      module Responses
        # jsonrpc version String
        VERSION = '2.0'

        #
        # Builds a result response.
        #
        # @param [Object] result
        #   The result object.
        #
        # @param [Integer, String] id
        #   The response id.
        #
        # @return [Hash]
        #
        def self.result(result,id)
          {
            'jsonrpc' => VERSION,
            'result'  => result,
            'id'      => id
          }
        end

        #
        # Builds an error response.
        #
        # @param [Hash] error
        #   The error object.
        #
        # @param [Integer, String, nil] id
        #   The response id.
        #
        # @return [Hash]
        #
        def self.error(error,id=nil)
          {
            'jsonrpc' => VERSION,
            'error'   => error,
            'id'      => id
          }
        end
      end
    end
  end
end
