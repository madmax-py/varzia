class RegistrationsController < ApplicationController
  allow_unauthenticated_access
  rate_limit to: 10, within: 1.hour, only: :create, with: -> { render json: { error: "too_many_requests" }, status: :too_many_requests }

  def create
    user = User.new(registration_params)

    if user.save
      session = start_session_for(user)
      render json: { user: user.as_json(only: MeController::FIELDS), token: session.token }, status: :created
    else
      render json: { errors: user.errors }, status: :unprocessable_content
    end
  end

  private
    def registration_params
      params.expect(user: [ :username, :email, :password, :display_name ])
    end
end
