module JSON
  module RPC
    #
    # Represents a JSON-RPC 2.0 error object.
    #
    module Errors

      ParseError = {
        'code'    => -32700,
        'message' => 'Parse error'
      }

      InvalidRequest = {
        'code'    => -32600,
        'message' => 'Invalid Request'
      }

      MethodNotFound = {
        'code'    => -32601,
        'message' => 'Method not found'
      }

      def self.data(data)
        case data
        when Exception
          {
            'class'     => data.class.to_s,
            'message'   => data.message,
            'backtrace' => data.backtrace
          }
        end
      end

      #
      # Builds a invalid params error object.
      #
      # @param [ArgumentError] exception
      #
      # @return [Hash]
      #
      def self.InvalidParams(exception)
        {
          'code'    => -32602,
          'message' => 'Invalid params',
          'data'    => data(exception)
        }
      end

      #
      # Builds a internal error object.
      #
      # @param [Exception] exception
      #
      # @return [Hash]
      #
      def self.InternalError(exception)
        {
          'code'    => -32603,
          'message' => 'Internal error',
          'data'    => data(exception)
        }
      end
    end
  end
end
