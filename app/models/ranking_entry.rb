# Derived from laughs and rebuilt by a job; treat as read-only in the app.
class RankingEntry < ApplicationRecord
  belongs_to :subject, polymorphic: true

  enum :period, { week: "week", month: "month" }, validate: true

  scope :for_users, -> { where(subject_type: "User") }
  scope :for_communities, -> { where(subject_type: "Community") }
  scope :leaderboard, ->(period, period_start) { where(period:, period_start:).order(:position) }
end
