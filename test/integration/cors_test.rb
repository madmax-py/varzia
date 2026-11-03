require "test_helper"

class CorsTest < ActionDispatch::IntegrationTest
  test "allows the web front end origin" do
    process :options, me_url, headers: {
      "Origin" => "http://localhost:5173",
      "Access-Control-Request-Method" => "GET",
      "Access-Control-Request-Headers" => "Authorization"
    }

    assert_equal "http://localhost:5173", response.headers["Access-Control-Allow-Origin"]
  end

  test "ignores unknown origins" do
    get me_url, headers: { "Origin" => "https://evil.example" }

    assert_nil response.headers["Access-Control-Allow-Origin"]
  end
end
