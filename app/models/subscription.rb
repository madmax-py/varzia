class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan

  enum :status, { active: "active", past_due: "past_due", canceled: "canceled" }, validate: true

  # A user has at most one active or past due subscription (enforced by a partial unique index).
  scope :current, -> { where(status: [ :active, :past_due ]) }

  validates :provider_ref, uniqueness: true, allow_nil: true
end
