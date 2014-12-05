module JSON
  module RPC
    class Service

      def initialize(namespace)
        @namespace = Namespace.new(namespace)
      end

      #
      # @param [Request::V1, Request::V2, Request::V2::Batch] request
      #
      # @return [Hash, nil]
      #
      def process_request(request)
        responses = case request
                    when V1::Request then V1::Responses
                    when V1::Request then V2::Responses
                    end

        id = request.id

        unless request.valid?
          return responses.call(Errors::InvalidRequest,id)
        end

        response = begin
                     value = @namespace.call(name,params)
                     responses.result(value,id)
                   rescue Namespace::MethodNotFoundError
                     responses.error(Errors::MethodNotFound,id)
                   rescue ArgumentError => exception
                     responses.call(Errors::InvalidParams(exception),id)
                   rescue Exception => exception
                     responses.call(Errors::InternalError(exception),id)
                   end

        unless request.notification?
          return response
        end
      end

      def process_batch(request)
        unless request.valid?
          return V2::Responses.error(Errors::InvalidRequest,request.id)
        end

        responses = request.map { |request|
          process_request(request)
        }.compact

        unless responses.empty?
          return responses
        end
      end

      def process(json)
        request = begin
                    Request.parse(json)
                  rescue JSON::ParserError
                    return V2::Responses.error(Errors::ParseError)
                  end

        response = case request
                   when V2::Request::Batch then process_batch(request)
                   else                         process_request(request)
                   end

        unless response.nil?
          response.to_json
        end
      end

    end
  end
end
