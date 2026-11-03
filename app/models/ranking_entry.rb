# Derived from laughs and rebuilt by a job; treat as read-only in the app.
class RankingEntry < ApplicationRecord
  enum :scope, { user: "user", community: "community" }, validate: true
  enum :period, { week: "week", month: "month" }, validate: true

  scope :leaderboard, ->(period, period_start) { where(period:, period_start:).order(:position) }

  def subject
    (user? ? User : Community).find(subject_id)
  end
end
