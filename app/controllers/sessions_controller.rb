class SessionsController < ApplicationController
  allow_unauthenticated_access only: :create
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render json: { error: "too_many_requests" }, status: :too_many_requests }

  # `login` accepts either the username (with or without @) or the email.
  def create
    user = User.authenticate_by(login_identifier => params[:login].to_s, password: params[:password].to_s)

    if user.nil?
      render json: { error: "invalid_credentials" }, status: :unauthorized
    elsif !user.active?
      render_inactive(user)
    else
      session = start_session_for(user)
      render json: { user: user.as_json(only: MeController::FIELDS), token: session.token }, status: :created
    end
  end

  def destroy
    Current.session.destroy
    head :no_content
  end

  private
    def login_identifier
      params[:login].to_s.match?(/\A[^@\s]+@[^@\s]+\z/) ? :email : :username
    end
end
