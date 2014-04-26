id = 42
v1_request = JSON::RPC::V1::Request.new(
  "method" => "foo",
  "params" => [1,2,3],
  "id"     => id
)
v2_request = JSON::RPC::V2::Request.new(
  "jsonrpc" => "2.0",
  "method"  => "foo",
  "params"  => [1,2,3],
  "id"      => id
)

assert("JSON::RPC::V1::Responses.result(result,id)") do
  result   = "bar"
  response = JSON::RPC::V1::Responses.result(result,id)

  assert_equal response['result'], result
  assert_nil   response['error']
  assert_equal response['id'],     id
end

assert("JSON::RPC::V1::Responses.error(error,id)") do
  error     = JSON::RPC::Errors::InvalidRequest
  response  = JSON::RPC::V1::Responses.error(error,id)

  assert_true  response.has_key?('result')
  assert_nil   response['result']
  assert_equal response['error'], error
  assert_equal response['id'], id
end

assert("JSON::RPC::V2::Responses.result(result,id)") do
  result   = "bar"
  response = JSON::RPC::V2::Responses.result(result,id)

  assert_equal response['jsonrpc'], "2.0"
  assert_equal response['result'],  result
  assert_false response.has_key?('error')
  assert_equal response['id'],      id
end

assert("JSON::RPC::V2::Responses.error(error,id)") do
  error     = JSON::RPC::Errors::InvalidRequest
  response  = JSON::RPC::V2::Responses.error(error,id)

  assert_equal response['jsonrpc'], "2.0"
  assert_false response.has_key?('result')
  assert_equal response['error'], error
  assert_equal response['id'], id
end
