require "test_helper"

class MeControllerTest < ActionDispatch::IntegrationTest
  test "returns the current user with private fields" do
    get me_url, headers: auth_headers_for(users(:fulano))

    assert_response :success
    user = response.parsed_body["user"]
    assert_equal "fulano@example.com", user["email"]
    assert_not user.key?("password_hash")
  end

  test "requires a token" do
    get me_url

    assert_response :unauthorized
    assert_equal 'Bearer realm="Application"', response.headers["WWW-Authenticate"]
  end

  test "rejects an invalid token" do
    get me_url, headers: { "Authorization" => "Bearer nao-existe" }

    assert_response :unauthorized
  end

  test "blocks a session whose user was banned after login" do
    user = users(:fulano)
    headers = auth_headers_for(user)
    user.banned!

    get me_url, headers: headers

    assert_response :forbidden
    assert_equal "account_banned", response.parsed_body["error"]
  end

  test "tracks when the session was last used" do
    user = users(:fulano)
    headers = auth_headers_for(user)

    get me_url, headers: headers

    assert_not_nil user.sessions.last.last_used_at
  end
end
