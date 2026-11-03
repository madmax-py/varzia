class MeController < ApplicationController
  # The owner also sees private fields such as email and status.
  FIELDS = %i[ id username email display_name avatar_url bio status created_at ].freeze

  def show
    render json: { user: current_user.as_json(only: FIELDS) }
  end
end
