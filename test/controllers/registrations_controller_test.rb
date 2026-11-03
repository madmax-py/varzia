require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "signs up and returns a working token" do
    assert_difference [ "User.count", "Session.count" ], 1 do
      post registration_url, params: { user: { username: "@Novato", email: "Novo@Example.com", password: "segredo123" } }, as: :json
    end

    assert_response :created
    body = response.parsed_body
    assert_equal "Novato", body.dig("user", "username")
    assert_equal "novo@example.com", body.dig("user", "email")
    assert_not body["user"].key?("password_hash")

    get me_url, headers: { "Authorization" => "Bearer #{body["token"]}" }
    assert_response :success
    assert_equal "Novato", response.parsed_body.dig("user", "username")
  end

  test "rejects taken username regardless of case" do
    assert_no_difference "User.count" do
      post registration_url, params: { user: { username: "FULANO", email: "outro@example.com", password: "segredo123" } }, as: :json
    end

    assert_response :unprocessable_content
    assert response.parsed_body.dig("errors", "username").present?
  end

  test "rejects missing password" do
    post registration_url, params: { user: { username: "semsenha", email: "sem@example.com" } }, as: :json

    assert_response :unprocessable_content
    assert response.parsed_body.dig("errors", "password").present?
  end

  test "requires the user wrapper" do
    post registration_url, params: { username: "solto" }, as: :json

    assert_response :bad_request
  end
end
