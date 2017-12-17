module RandomHelper
  private

  def random_multiplier(max_value = 2)
    random_org_response = HTTParty.post(
      'https://api.random.org/json-rpc/1/invoke',
      body: random_org_request_body(max_value)
    )

    JSON(random_org_response.body)['result']['random']['data'][0]
  end

  def random_org_request_body(max_value)
    {
      'jsonrpc' => '2.0',
      'method' => 'generateIntegers',
      'params' => random_org_request_body_params(max_value),
      'id' => 24_780
    }.to_json
  end

  def random_org_request_body_params(max_value)
    {
      'apiKey' => ENV['RANDOM_ORG_API_KEY'],
      'n' => 1,
      'min' => 0,
      'max' => max_value,
      'replacement' => true,
      'base' => 10
    }
  end
end