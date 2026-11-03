require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "logs in with username" do
    post session_url, params: { login: "fulano", password: "password" }, as: :json

    assert_response :created
    assert response.parsed_body["token"].present?
    assert_equal users(:fulano).id, response.parsed_body.dig("user", "id")
  end

  test "logs in with @username in any case" do
    post session_url, params: { login: "@FULANO", password: "password" }, as: :json

    assert_response :created
  end

  test "logs in with email" do
    post session_url, params: { login: "Fulano@Example.com", password: "password" }, as: :json

    assert_response :created
  end

  test "stores only the token digest" do
    post session_url, params: { login: "fulano", password: "password" }, as: :json

    token = response.parsed_body["token"]
    assert_equal Session.digest(token), Session.last.token_digest
    assert_nil Session.find_by(token_digest: token)
  end

  test "rejects wrong password and unknown user the same way" do
    post session_url, params: { login: "fulano", password: "errada" }, as: :json
    assert_response :unauthorized
    wrong_password = response.parsed_body

    post session_url, params: { login: "ninguem", password: "password" }, as: :json
    assert_response :unauthorized
    assert_equal wrong_password, response.parsed_body
  end

  test "refuses banned users" do
    post session_url, params: { login: "banido", password: "password" }, as: :json

    assert_response :forbidden
    assert_equal "account_banned", response.parsed_body["error"]
  end

  test "logout revokes only the current token" do
    user = users(:fulano)
    current = auth_headers_for(user)
    other_device = auth_headers_for(user)

    delete session_url, headers: current
    assert_response :no_content

    get me_url, headers: current
    assert_response :unauthorized

    get me_url, headers: other_device
    assert_response :success
  end
end
