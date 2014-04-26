module JSON
  module RPC
    class Namespace

      class MethodNotFoundError < NoMethodError
      end

      def initialize(root)
        @root = root
      end

      #
      # Resolves the namespace.
      #
      # @param [String] path
      #   The path to the namespace. (ex: `foo.bar`)
      #
      # @return [Module, nil]
      #
      def namespace_of(method)
        namespace = @root

        path.split('.').each do |name|
          name.capitalize!

          namespaces = namespace.constants(false).map { |const| const.to_s }

          unless namespaces.include?(name)
            return
          end

          namespace = namespace.const_get(name)

          unless namespace.class == Module
            return
          end
        end

        return namespace
      end

      #
      # 
      # @return [(Module, String)]
      #   Returns the module and name of the resolved method.
      #   If the module cannot be resolved, it will be `nil`.
      #   If the method cannot be found in the module, it will be `nil`.
      #
      def method(name)
        namespace = if name.include?('.') then namespace(name)
                    else                       @root
                    end

        unless namespace
          return
        end

        methods = namespace.methods(false).map { |name| name.to_s }

        unless methods.include?(method)
          return [namespace, nil]
        end

        return [namespace, method]
      end

      #
      # @raise [NoSuchMethodError]
      #   The method could not be found.
      #
      def call(name,params)
        namespace, method = method(name)

        unless (namespace && method)
          raise(MethodNotFound,"no such method #{method.inspect}")
        end

        case params
        when Hash  then scope.__send__(method,params)
        when Array then scope.__send__(method,*params)
        else            scope.__send__(method)
        end
      end

    end
  end
end
