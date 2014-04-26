def assert_json(json)
  assert("JSON::RPC::Request.parse(#{json.inspect})") do
    yield JSON::RPC::Request.parse(json)
  end
end

assert_raise(JSON::ParserError) do
  assert_json("foo") do |request|
  end
end

assert_json('{"jsonrpc":"2.0","method":"foo","params":[],"id":1}') do |request|
  assert_equal request.class, JSON::RPC::V2::Request
end

assert_json("[]") do |request|
  assert_equal request.class, JSON::RPC::V2::Request::Batch
  assert_false request.valid?
end

assert_json('[{}, {"jsonrpc":"2.0","method":"foo","params":[],"id":1}]') do |request|
  assert_equal request.class, JSON::RPC::V2::Request::Batch
end

def assert_v1_request(json)
  assert("JSON::RPC::V1::Request.new(#{json.inspect})") do
    yield JSON::RPC::V1::Request.new(json)
  end
end

def assert_v2_request(json)
  assert("JSON::RPC::V2::Request.new(#{json.inspect})") do
    yield JSON::RPC::V2::Request.new(json)
  end
end

def assert_invalid_v1_request(json)
  assert("JSON::RPC::V1::Request.new(#{json.inspect}).valid?") do
    request = JSON::RPC::V1::Request.new(json)

    assert_false request.valid?
  end
end

def assert_invalid_v2_request(json)
  assert("JSON::RPC::V2::Request.new(#{json.inspect}).valid?") do
    request = JSON::RPC::V2::Request.new(json)

    assert_false request.valid?
  end
end

assert_invalid_v1_request(1)
assert_invalid_v1_request([])
assert_invalid_v1_request({})
assert_invalid_v1_request({'method' => nil})
assert_invalid_v1_request({'method' => 42})
assert_invalid_v1_request({'method' => 'foo', 'params' => nil})
assert_invalid_v1_request({'method' => 'foo', 'params' => {}})

assert_invalid_v2_request(1)
assert_invalid_v2_request([])
assert_invalid_v2_request({})
assert_invalid_v2_request({"jsonrpc" => nil})
assert_invalid_v2_request({"jsonrpc" => 42})
assert_invalid_v2_request({"jsonrpc" => "42"})
assert_invalid_v2_request({"jsonrpc" => "2.0"})
assert_invalid_v2_request({"jsonrpc" => "2.0", "method" => nil})
assert_invalid_v2_request({"jsonrpc" => "2.0", "method" => 42})
assert_invalid_v2_request({"jsonrpc" => "2.0", "method" => "foo", "params" => nil})
assert_invalid_v2_request({"jsonrpc" => "2.0", "method" => "foo", "params" => 42})
assert_invalid_v2_request({"jsonrpc" => "2.0", "method" => "foo", "params" => [1,2,3], "id" => nil})

assert_v1_request({"method" => "foo", "id" => 42}) do |request|
  assert_equal request.method,  "foo"
  assert_equal request.params,  nil
  assert_equal request.id,      42
end

assert_v1_request({"method" => "foo", "params" => [1,2,3], "id" => 42}) do |request|
  assert_equal request.method,  "foo"
  assert_equal request.params,  [1,2,3]
  assert_equal request.id,      42
end

assert_v2_request({"jsonrpc" => "2.0", "method" => "foo", "id" => 42}) do |request|
  assert_equal request.jsonrpc, "2.0"
  assert_equal request.method,  "foo"
  assert_equal request.params,  nil
  assert_equal request.id,      42
end

assert_v2_request({"jsonrpc" => "2.0", "method" => "foo", "params" => [1,2,3], "id" => 42}) do |request|
  assert_equal request.jsonrpc, "2.0"
  assert_equal request.method,  "foo"
  assert_equal request.params,  [1,2,3]
  assert_equal request.id,      42
end

assert("JSON::RPC::V1::Request#notification?") do
  call = JSON::RPC::V1::Request.new(
    "method"  => "foo",
    "params"  => [1,2,3],
    "id"      => 42
  )

  assert_false call.notification?

  notification = JSON::RPC::V1::Request.new(
    "method"  => "foo",
    "params"  => [1,2,3],
    "id"      => nil
  )

  assert_true notification.notification?
end

assert("JSON::RPC::V1::Request#notification?") do
  call = JSON::RPC::V1::Request.new(
    "method"  => "foo",
    "params"  => [1,2,3],
    "id"      => 42
  )

  assert_false call.notification?

  notification = JSON::RPC::V1::Request.new(
    "method"  => "foo",
    "params"  => [1,2,3]
  )

  assert_true notification.notification?
end
