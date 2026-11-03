# Token auth: clients send `Authorization: Bearer <token>`, where the token
# comes from POST /session or POST /registration.
module Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :require_authentication
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def current_user = Current.user

    def require_authentication
      session = find_session_by_token
      return render_unauthorized unless session
      return render_inactive(session.user) unless session.user.active?

      session.touch_last_used
      Current.session = session
    end

    def find_session_by_token
      authenticate_with_http_token { |token, _options| Session.includes(:user).find_by_token(token) }
    end

    def start_session_for(user)
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
    end

    def render_unauthorized
      response.headers["WWW-Authenticate"] = 'Bearer realm="Application"'
      render json: { error: "not_authenticated" }, status: :unauthorized
    end

    def render_inactive(user)
      render json: { error: "account_#{user.status}" }, status: :forbidden
    end
end
