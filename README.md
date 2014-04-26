mruby-json-rpc
--------------

A pure-ruby JSON-RPC server library for [mruby].

Features
========

* Supports JSON RPC [1.0] and [2.0].
* Supports batch requests.
* Supports notifications.
* Prevents accessing inherited Ruby constants (ex: `Kernel`) or methods
  (ex: `instance_eval`).

Example
=======

    module MyRPC
      def self.method1
        # ...
      end

      def self.method2(x,y,z)
        # ...
      end

      def self.method3(options={})
        # ...
      end

      module Namespace
        def self.method4(*args)
          # ...
        end
      end
    end
    
    json_rpc = JSON::RPC::Service.new(MyRPC)
    
    json_rpc.call('{"jsonrpc":"2.0","method":"method1","id":1}')
    
    json_rpc.call('{"jsonrpc":"2.0","method":"method2","params":[1,2,3],"id":2}')
    
    json_rpc.call('{"jsonrpc":"2.0","method":"method3","params":{"x":1,"y":2,"z":2},"id":3}')
    
    json_rpc.call('{"jsonrpc":"2.0","method":"Namespace.method4","params":[1,2,"foo","bar"],"id":4}')

[1.0]: http://www.jsonrpc.org/wiki/specification
[2.0]: http://www.jsonrpc.org/specification

[mruby]: https://github.com/mruby/mruby#readme
