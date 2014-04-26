assert("JSON::RPC::Errors::ParseError") do
  error = JSON::RPC::Errors::ParseError

  assert_equal error['code'],    -32700
  assert_equal error['message'], 'Parse error'
end

assert("JSON::RPC::Errors::InvalidRequest") do
  error = JSON::RPC::Errors::InvalidRequest

  assert_equal error['code'],    -32600
  assert_equal error['message'], 'Invalid Request'
end

assert("JSON::RPC::Errors::MethodNotFound") do
  error = JSON::RPC::Errors::MethodNotFound

  assert_equal error['code'],    -32601
  assert_equal error['message'], 'Method not found'
end

assert("JSON::RPC::Errors::invalid_params") do
  exception = ArgumentError.new("wrong number of arguments (1 for 0)")
  error = JSON::RPC::Errors::InvalidParams(exception)

  assert_equal error['code'],    -32602
  assert_equal error['message'], 'Invalid params'
end

assert("JSON::RPC::Errors::InternalError") do
  exception = RuntimeError.new("foo")

  error = JSON::RPC::Errors::InternalError(exception)

  assert_equal error['code'],    -32603
  assert_equal error['message'], 'Internal error'

  assert_equal error['data']['class'],     exception.class.to_s
  assert_equal error['data']['message'],   exception.message
  assert_equal error['data']['backtrace'], exception.backtrace
end
